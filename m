Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab3BYPpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:45:54 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57194 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3BYPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:45:53 -0500
Date: Mon, 25 Feb 2013 15:45:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130225154549.GD13605@srcf.ucam.org>
References: <30665.1361461678@warthog.procyon.org.uk>
 <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
 <20130221164244.GA19625@srcf.ucam.org>
 <87ppzo79in.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppzo79in.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 03:28:32PM +0100, Florian Weimer wrote:

> But what puzzles me most is why anyone would assume that the UEFI
> application signing process somehow ensures that the embedded
> certificate is non-malicious.  We cannot even track it back to the
> submitter because the third-pary market place UEFI authority only
> issues pseudonymous proxy certificates.  This utterly useless for any
> purpose whatsoever, with the notable exception of avoding one
> additional step when setting up a dual-boot machine (which will not
> even work reliably until we switch to overwriting the Windows boot
> loader, like in the pre-UEFI days).

If your firmware trusts objects signed by Microsoft, you have to assume 
that objects signed by Microsoft are trustworthy. There's no way to 
build a security model otherwise. Are Microsoft trustworthy? We don't 
know. If you don't trust Microsoft, remove their key from db.

> Seriously, folks, can we go back one step and discuss what problem you
> are trying to solve?  Is it about allowing third-party kernel modules
> in an environment which does not allow unsigned ring 0 code execution?

The problem I'm trying to solve is "Don't permit Linux to be used as a 
bootloader for backdoored versions of other operating systems". Any 
other security benefit is a happy side effect.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
