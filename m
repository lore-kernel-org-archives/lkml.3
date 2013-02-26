Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab3BZBAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:00:06 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55245 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3BZA77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:59:59 -0500
Date: Mon, 25 Feb 2013 16:59:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226005955.GA19686@kroah.com>
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18738.1361836265@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:51:05PM +0000, David Howells wrote:
> 
> Florian Weimer <fw@deneb.enyo.de> wrote:
> 
> > Seriously, folks, can we go back one step and discuss what problem you
> > are trying to solve?  Is it about allowing third-party kernel modules
> > in an environment which does not allow unsigned ring 0 code execution?
> 
> Let me try and lay things out:
> 
>  (1) Like it or not, the reality is that machines exist that have UEFI secure
>      boot.  We want it to be possible for people to be able to install and run
>      Linux on these.
> 
>  (2) Unless secure boot is completely disabled, the operating system boot
>      loader must be signed by a key that's in the UEFI key database.
> 
>  (3) We don't want to stop people from being able to dual boot Windows (and
>      other OS's - but Windows is the problematic one), therefore we will need
>      to be able to operate with secure mode enabled.
> 
>  (4) Machines are shipped with a Microsoft root key.  They are not shipped
>      with a Microsoft-independent root key from Red Hat or, say, the Linux
>      Foundation.
> 
>  (5) Unless we get the administrator to add a key prior to Linux installation,
>      Linux cannot be booted on a secure UEFI machine - unless the boot loader
>      is signed by Microsoft's key.
> 
>  (6) To maintain secure boot mode, the kernel must be signed and the boot
>      loader must check the signature on it.  The key must be either compiled
>      into the bootloader (and thus validated by the bootloader signature) or
>      must reside in the UEFI database.
> 
>      [*] Note: This step is simplified a bit.

That's all fine, and now your machine can boot both Linux and Windows
wonderfully.  Distros have shipped code doing this for a short while now
thanks to Matthew's and other developer's effort in writing a UEFI
bootloader / shim that Microsoft has signed.

>  (7) To maintain secure boot mode, the kernel modules must be signed and the
>      kernel must check the signature on them.  The key must be compiled into
>      the kernel or the bootloader or must reside in the UEFI database.

Wait right here.  This is NOT mandated by UEFI, nor by anyone else.  It
might be a nice thing that some people and companies want to implement,
but please don't think that some external entity is requiring that Linux
implement this, that is not true.

> At this point, you have the kernel booted in secure boot mode.  Now, there are
> several issues we have to deal with going on from here if we want to *stay* in
> secure boot mode:

Well, it's all how you define "secure boot mode", isn't it.  This seems
to be some random thing that people are making up as they go along ("We
must sign firmware!")

>  (A) Unsigned modules.  These may not be loaded in secure boot mode.  At all.

Why not?  Who says so?  See, now you really don't have an argument
besides "the policy I am deciding to make up says so," right?

Same for your other "requirements", these are all self-inflicted, no one
that I can determine is mandating any of these, who is deciding that
Linux MUST follow this policy?  I'm not saying that they are not nice
things to have, personally, I want some of these things for my own
machines just to make things more secure, but again, these are "I want
to have", not "Someone else is saying Linux MUST have."

thanks,

greg k-h
