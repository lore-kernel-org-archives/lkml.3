Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab3KMOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:08:37 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:33987 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759163Ab3KMOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:08:32 -0500
Date: Wed, 13 Nov 2013 14:08:14 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many entries
 to nvram.
Message-ID: <20131113140647.GK22636@console-pimps.org>
References: <87fvr3h3b9.fsf@redhat.com>
 <20131111110701.GE22636@console-pimps.org>
 <87eh6nt8oo.fsf@redhat.com>
 <20131113112052.GJ22636@console-pimps.org>
 <878uws1msy.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uws1msy.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov, at 08:57:49PM, Madper Xie wrote:
> 
> matt@console-pimps.org writes:
> 
> > On Mon, 11 Nov, at 08:38:31PM, Madper Xie wrote:
> >> 
> >> matt@console-pimps.org writes:
> >> 
> >> > On Mon, 11 Nov, at 02:15:22PM, Madper Xie wrote:
> >> >> Howdy all,
> >> >>   For now we ensure at least ~5kb free space. But my dell xps still
> >> >>   become a brick after I add too many entries to my nvram. So maybe 5kb
> >> >>   is not safe enough. and 5kb is just aginst Samsung's laptop.
> >> >>   So should we enlarge EFI_MIN_RESERVE?
> >> >
> >
> > OK, that's pretty conclusive. Thanks.
> >
> Ouch, Sorry. My mistake. Seems filling too much entries to nvram is not
> the murderer...
> For testing, I using following command to fill my nvram:
> head -c20480 /dev/urandom | efibootmgr --quiet --create --append-binary-args - 
> 
> For occupy lots of nvram space, I run it many times. But when I try to
> find the threshold, I find the real murderer is that command. I mean my
> dell xps will bricked even if I just run the command once and have more
> than 100kb free space...
> 
> So the murderer is the new added boot entry. I don't really know if it's
> still a bug. And I apologize for my mistake. :-(

OK, it looks like the firmware Boot Manager gets very confused when it
tries to parse the Boot Load Option you created with efibootmgr. This
looks like a general firmware bug and not something we need to worry
about in the kernel.

-- 
Matt Fleming, Intel Open Source Technology Center
