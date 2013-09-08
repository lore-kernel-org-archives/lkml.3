Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3IHHVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 03:21:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3IHHVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 03:21:06 -0400
Date: Sun, 8 Sep 2013 00:24:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Message-ID: <20130908072408.GA5092@kroah.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
 <20130908064027.GA3587@kroah.com>
 <1378622648.2300.4.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378622648.2300.4.camel@x230>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 06:44:08AM +0000, Matthew Garrett wrote:
> On Sat, 2013-09-07 at 23:40 -0700, Greg KH wrote:
> > On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
> > > kexec permits the loading and execution of arbitrary code in ring 0, which
> > > is something that module signing enforcement is meant to prevent. It makes
> > > sense to disable kexec in this situation.
> > 
> > I see no match between kexec and signed kernel modules.
> 
> sig_enforce is there to prevent anyone (including root) from installing
> new kernel code in the running kernel.

No, it's to enforce kernel modules to be signed or not.  That's all.

> Allowing kexec to run untrusted code allows root to install new kernel
> code in the running kernel.

Which has nothing to do with signed kernel modules.

> At the most trivial level, grab the address of sig_enforce from
> kallsyms, jump to a kernel that doesn't enforce STRICT_DEVMEM, modify
> sig_enforce, jump back to the old kernel.

Which proves what?

> > In fact, I personally _want_ signed kernel modules, and still the option
> > to run kexec.  kexec is to run a whole new kernel/OS, not a tiny kernel
> > module.
> 
> No, kexec is to run anything. It's expressly not limited to launching
> new kernels. It's easiest to demonstrate an attack using a Linux kernel,
> but you could launch a toy payload that did nothing other than modify
> one byte and then returned to the launch kernel.

Fair enough, but again, this has nothing to do with signed kernel
modules.

If you are really worried about kexec doing something like this, then
add signed kexec binary support, but don't suddenly stop kexec from
working just because signed modules are enabled, the two have nothing to
do with each other.

> > If you apply this, you break everyone who is currently relying on kexec
> > (i.e. kdump, bootloaders, etc.), from using signed kernel modules, which
> > personally, seems like a very bad idea.
> 
> Enforcing signed modules provides you with no additional security if you
> have kexec enabled. It's better to make that obvious.

Then document the heck out of it, don't disable a valid use case just
because it possibly could be used in some way that is different from the
original system.

If you take this to an extreme, kexec shouldn't be here at all, as it
can do anything in the kernel wherever it wants to.

kexec has nothing to do with signed modules, don't tie them together.

thanks,

greg k-h
