Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3JHWts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 18:49:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab3JHWtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 18:49:47 -0400
Date: Tue, 8 Oct 2013 15:48:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008224840.GA15303@kroah.com>
References: <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
 <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
 <20131008031152.GA8218@localhost>
 <20131008121742.GA29280@localhost>
 <20131008221417.GF25034@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008221417.GF25034@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:14:17PM +0100, Russell King - ARM Linux wrote:
> On Tue, Oct 08, 2013 at 08:17:42PM +0800, Fengguang Wu wrote:
> > I find the above debug messages very helpful in locating the buggy
> > driver. How about enabling it whenever CONFIG_DEBUG_KOBJECT_RELEASE is
> > enabled? Something like
> > 
> >  #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
> > -       pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
> > +       printk(KERN_INFO "kobject: '%s' (%p): %s, parent %p (delayed)\n",
> >                  kobject_name(kobj), kobj, __func__, kobj->parent);
> > 
> > pr_debug() won't be displayed by default, and it depends on
> > CONFIG_DYNAMIC_DEBUG.
> 
> Please consider using pr_info() instead of printk(KERN_INFO - it's
> slightly less typing.
> 
> I can see that being a useful change while we have these problematical
> instances to track down, but I do wonder whether it'll make the thing
> too noisy.  Does anyone have other opinions on this point?  Linus?
> Greg?

It's going to make things really noisy at boot time, but then it should
settle down and not be bad at all.  Let's try it and see if it helps or
not.

thanks,

greg k-h
