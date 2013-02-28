Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab3B1T0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:26:32 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:47178 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759793Ab3B1T0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:26:30 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <87ppzo79in.fsf@mid.deneb.enyo.de>
	<30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com> <8738wgsweq.fsf@mid.deneb.enyo.de>
	<512F7B0E.1030404@genband.com>
Date: Thu, 28 Feb 2013 20:26:17 +0100
In-Reply-To: <512F7B0E.1030404@genband.com> (Chris Friesen's message of "Thu,
	28 Feb 2013 09:43:10 -0600")
Message-ID: <87lia8nsti.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen:

> On 02/28/2013 01:57 AM, Florian Weimer wrote:
>
>> In any case, there's another reading of the UEFI Secure Boot
>> requirements: you may run any code you wish after calling
>> ExitBootServices().  That could be an unsigned, traditional GRUB.  But
>> this will not generally address the issue of dual-booting Windows 8 in
>> such a way that Windows sees that the device has enabled Microsoft
>> Secure Boot.
>
> Would it be possible to have a signed bootloader that allows booting
> Win8 from within the secure environment, or it could exit the secure
> environment and run unsigned grub?

On systems where the firmware supports multiple boot loaders, this
would work.

On systems which support just one boot loader, the next-stage boot
loader could be signed or not, it would not have access to the
privileged Secure Boot environment.  The decision to boot the
Secure-Boot-capable operating system would have to be made before
calling ExitBootServices(), otherwise that operating system will not
see Secure Boot support.
