Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3LSCfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:35:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab3LSCff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:35:35 -0500
Date: Thu, 19 Dec 2013 10:35:24 +0800
From: Dave Young <dyoung@redhat.com>
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, sebastian.capella@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use initmpfs even if there's root= cmdline
Message-ID: <20131219023524.GB2070@darkstar.nay.redhat.com>
References: <20131212092542.GA14218@dhcp-16-126.nay.redhat.com>
 <20131213023814.GA5519@dhcp-16-126.nay.redhat.com>
 <52B1E0A2.2030202@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B1E0A2.2030202@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:51:30AM -0600, Rob Landley wrote:
> 
> 
> On 12/12/13 20:38, Dave Young wrote:
> >On 12/12/13 at 05:25pm, Dave Young wrote:
> >>
> >>Current code use ramfs instead of tmpfs for stub when root= defined.
> >>
> >>But for real use case with initramfs, usually there's like cmdline like
> >>root=UUID=$UUID the root dev is the real device. For that case we have
> >>no way to use initmpfs, thus this patch removes the limitation so tmpfs
> >>can benefit more people.
> 
> The reason I did that was if you specify a root= then you don't want
> to _stay_ on rootfs. You specify root= so either the kernel does
> switch_root for you, or so rootfs does a swich_root at the end.
> 
> The point of initmpfs is that when rootfs _is_ the "real" root
> device, it can benefit from being tmpfs. When you're just goign to
> switch to a different root device, tmpfs doesn't make much
> difference.

The reason make sense to most of users. Thanks for the info.
For Fedora kdump initramfs there's different requirement though, we do the
vmcore capturing in ramfs with root=, the root= is not necessay in most of
the cases because we will reboot immediately after vmcore capturing finish.
There's one potential exception is that we could switch to real root in
case of capturing failure. Another thing is we use dracut to create initramfs
and dracut has a limitation that root= is a must-have param.

> 
> >Discussed with Vivek Goyal about the kdump use case, I missed one thing that
> >tmpfs has default size limit though we can tune it.
> >
> >So I will think more about it, will address this later, please ignore this
> >patch.
> 
> I have a vague todo item of feeding rootflags= through to initmpfs,
> but that's really intended to specify flags for root=. There isn't
> really an existing command line option to specify initramfs flags
> because ramfs doesn't care.
> 
> It was one of those "only parse rootflags= for initmpfs when there's
> no root=" vs "create a new rdrootflags= ala rdinit= even though
> that's a subtly wrong name these days..." and it went on the todo
> list because neither approach was obviously superior.
> 
> Happy to take suggestions and whip up a patch if this is
> inconveniencing somebody. :)

It would be great that initmpfs can use the whole memory on demand by default at
the same time we can avoid the deadlock mentioned about OOM handler.

For this purpose no need for extra flags? For other flags maybe "initmpfsflags="?

Thanks
Dave
