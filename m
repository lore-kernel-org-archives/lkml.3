Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3BZNea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:34:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab3BZNe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:34:28 -0500
Date: Tue, 26 Feb 2013 14:34:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: David Howells <dhowells@redhat.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
In-Reply-To: <18738.1361836265@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1302261427020.14180@twin.jikos.cz>
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org> <18738.1361836265@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, David Howells wrote:

>  (G) Suspend to disk.  This is not permitted if it's possible to then alter
>      the image and resume it.

Tangetial to this discussion, but worth mentioning anyway: this can be 
solved in a secure way in cooperation with trusted bootloader (such as 
shim); bootloader can be (re-)generating a new keypair on each and every 
boot, providing it to kernel. Kernel then signs the hibernation image and 
discards the private key.

During resume, the image signature (as public key still exists) can be 
verified, and new keypair is generated for potential subsequent 
hibernation again.
The public key is preserved in trusted UEFI variable, giving it the 
exactly same level of security as for example MOK has.

This still has some challenges (having enough entropy available for 
keypair generation in bootloader is unlikely, but PRNG might be 
sufficient), but it is doable.

-- 
Jiri Kosina
SUSE Labs

