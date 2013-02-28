Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab3B1UX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:23:59 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:41007 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3B1UX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:23:57 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com> <8738wgsweq.fsf@mid.deneb.enyo.de>
	<512F7B0E.1030404@genband.com> <20130228193023.GA8090@srcf.ucam.org>
	<87d2vkns4m.fsf@mid.deneb.enyo.de>
	<20130228195321.GA8769@srcf.ucam.org>
Date: Thu, 28 Feb 2013 21:23:45 +0100
In-Reply-To: <20130228195321.GA8769@srcf.ucam.org> (Matthew Garrett's message
	of "Thu, 28 Feb 2013 19:53:21 +0000")
Message-ID: <87zjyombla.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> On Thu, Feb 28, 2013 at 08:41:13PM +0100, Florian Weimer wrote:
>> * Matthew Garrett:
>> 
>> >> Would it be possible to have a signed bootloader that allows booting
>> >> Win8 from within the secure environment, or it could exit the secure
>> >> environment and run unsigned grub?
>> >
>> > What would stop the unsigned grub from installing a firmware hook that 
>> > lies about whether or not Secure Boot is enabled, and then booting 
>> > Windows?
>> 
>> Windows would not have access to the product key because it is stored
>> in a variable without EFI_VARIABLE_RUNTIME_ACCESS, so WGA and other
>> checks will fail, and the user will notice.
>
> grub's running before ExitBootServices(), because otherwise it has no 
> way to actually read anything off disk. Or draw to the screen.

Sorry, if Linux can read from the disk after ExitBootServices(), so
can a boot loader.  Actually, we could boot Linux directly, with an
initrd which contains a boot selector, and use kexec if the chosen
kernel doesn't match the initial one.
