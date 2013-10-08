Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3JHWOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 18:14:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40782 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3JHWOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 18:14:38 -0400
Date: Tue, 8 Oct 2013 23:14:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008221417.GF25034@n2100.arm.linux.org.uk>
References: <20131007051038.GA9764@localhost> <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com> <20131007083505.GA22585@localhost> <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com> <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com> <20131008020918.GA1220@localhost> <20131008021452.GA6456@localhost> <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com> <20131008031152.GA8218@localhost> <20131008121742.GA29280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008121742.GA29280@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 08:17:42PM +0800, Fengguang Wu wrote:
> I find the above debug messages very helpful in locating the buggy
> driver. How about enabling it whenever CONFIG_DEBUG_KOBJECT_RELEASE is
> enabled? Something like
> 
>  #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
> -       pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
> +       printk(KERN_INFO "kobject: '%s' (%p): %s, parent %p (delayed)\n",
>                  kobject_name(kobj), kobj, __func__, kobj->parent);
> 
> pr_debug() won't be displayed by default, and it depends on
> CONFIG_DYNAMIC_DEBUG.

Please consider using pr_info() instead of printk(KERN_INFO - it's
slightly less typing.

I can see that being a useful change while we have these problematical
instances to track down, but I do wonder whether it'll make the thing
too noisy.  Does anyone have other opinions on this point?  Linus?
Greg?
