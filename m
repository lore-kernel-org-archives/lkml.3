Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab3BZPL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:11:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497Ab3BZPLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:11:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130226005955.GA19686@kroah.com>
References: <20130226005955.GA19686@kroah.com> <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <18738.1361836265@warthog.procyon.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, Florian Weimer <fw@deneb.enyo.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Tue, 26 Feb 2013 15:11:41 +0000
Message-ID: <4474.1361891501@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

> >  (6) To maintain secure boot mode, the kernel must be signed and the boot
> >      loader must check the signature on it.  The key must be either compiled
> >      into the bootloader (and thus validated by the bootloader signature) or
> >      must reside in the UEFI database.
> > 
> >      [*] Note: This step is simplified a bit.
> 
> That's all fine, and now your machine can boot both Linux and Windows
> wonderfully.  Distros have shipped code doing this for a short while now
> thanks to Matthew's and other developer's effort in writing a UEFI
> bootloader / shim that Microsoft has signed.
> 
> >  (7) To maintain secure boot mode, the kernel modules must be signed and the
> >      kernel must check the signature on them.  The key must be compiled into
> >      the kernel or the bootloader or must reside in the UEFI database.
> 
> Wait right here.  This is NOT mandated by UEFI, nor by anyone else.  It
> might be a nice thing that some people and companies want to implement,
> but please don't think that some external entity is requiring that Linux
> implement this, that is not true.

What's the point in having the bootloader check the signature on a kernel
(which you say is fine) if you then permit it to be modified arbitrarily once
it is running?  If you don't have signed modules then there's no point having
signed kernels (assuming you don't disable module loading).

David
