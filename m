Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab3BZQuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:50:12 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:56486 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab3BZQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:50:08 -0500
Date: Tue, 26 Feb 2013 08:50:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226165003.GA28593@kroah.com>
References: <20130226005955.GA19686@kroah.com>
 <87ppzo79in.fsf@mid.deneb.enyo.de>
 <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <18738.1361836265@warthog.procyon.org.uk>
 <4474.1361891501@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4474.1361891501@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:11:41PM +0000, David Howells wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > >  (6) To maintain secure boot mode, the kernel must be signed and the boot
> > >      loader must check the signature on it.  The key must be either compiled
> > >      into the bootloader (and thus validated by the bootloader signature) or
> > >      must reside in the UEFI database.
> > > 
> > >      [*] Note: This step is simplified a bit.
> > 
> > That's all fine, and now your machine can boot both Linux and Windows
> > wonderfully.  Distros have shipped code doing this for a short while now
> > thanks to Matthew's and other developer's effort in writing a UEFI
> > bootloader / shim that Microsoft has signed.
> > 
> > >  (7) To maintain secure boot mode, the kernel modules must be signed and the
> > >      kernel must check the signature on them.  The key must be compiled into
> > >      the kernel or the bootloader or must reside in the UEFI database.
> > 
> > Wait right here.  This is NOT mandated by UEFI, nor by anyone else.  It
> > might be a nice thing that some people and companies want to implement,
> > but please don't think that some external entity is requiring that Linux
> > implement this, that is not true.
> 
> What's the point in having the bootloader check the signature on a kernel
> (which you say is fine) if you then permit it to be modified arbitrarily once
> it is running?  If you don't have signed modules then there's no point having
> signed kernels (assuming you don't disable module loading).

I'm not saying that it isn't something nice to have, I really like
signed kernel modules.  I'm saying that the key-signing of our Linux
shim bootloader is not dependant on having signed kernel modules, that's
all.  This has been proven by the fact that we have gotten bootloaders
signed without having this functionality in the kernel at the time.

thanks,

greg k-h
