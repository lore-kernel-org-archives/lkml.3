Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3CZSPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab3CZSPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:15:16 -0400
Date: Tue, 26 Mar 2013 14:14:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
Message-ID: <20130326181418.GA6775@redhat.com>
References: <20130320163131.GE2273@redhat.com>
 <1363807329-24975-1-git-send-email-yinghai@kernel.org>
 <20130325194245.GA7357@redhat.com>
 <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 02:50:18PM -0700, Yinghai Lu wrote:
> On Mon, Mar 25, 2013 at 12:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > So it is a forgone conclusion that these new kernel changes to
> > crashkernel=X in 3.9 are incompatible with older kexec-tools and one
> > needs to upgrade kexec-tools.
> 
> I thought that you and hpa all agreed that user need to update kexec-tools with
> new kernel v3.9. It that still right?

I can update kexec-tools and I don't have problems with that. I am only
concerned about some xyz user complaining that new kernel stopped working
with old kexec-tools and then possibly face the rant from Linus about
breaking user space. :-)

To me we could maintain backward compatibility by retaining the existing
behavior of crashkernle=X. That is  look for specificied memory below
896M first and then go higher.

And hide new semantics behind new kernel parameters or by extending
existing parameter (say crashkernel=X:search_high_first) to specify how
to search for reserved memory.

In both the cases we should probably retain the logic of auto reserving
low memory for software iotlb and let user opt out if there is no need.

So we don't have a strong reason that why we should break existing
kexec-tools. So I would prefer not to break it.

But I think this is hpa's decision.

Thanks
Vivek
