Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab3BYO2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:28:45 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:43182 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759705Ab3BYO2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:28:44 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
Date: Mon, 25 Feb 2013 15:28:32 +0100
In-Reply-To: <20130221164244.GA19625@srcf.ucam.org> (Matthew Garrett's message
	of "Thu, 21 Feb 2013 16:42:44 +0000")
Message-ID: <87ppzo79in.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> There's only one signing authority, and they only sign PE binaries.

There are at least two, with different policies, albeit run by the
same organization.  Actually, we don't know how many authorities are
out there which have non-localized reach, so it's ... interesting to
attempt to construct any form of security based on that.

But what puzzles me most is why anyone would assume that the UEFI
application signing process somehow ensures that the embedded
certificate is non-malicious.  We cannot even track it back to the
submitter because the third-pary market place UEFI authority only
issues pseudonymous proxy certificates.  This utterly useless for any
purpose whatsoever, with the notable exception of avoding one
additional step when setting up a dual-boot machine (which will not
even work reliably until we switch to overwriting the Windows boot
loader, like in the pre-UEFI days).

Seriously, folks, can we go back one step and discuss what problem you
are trying to solve?  Is it about allowing third-party kernel modules
in an environment which does not allow unsigned ring 0 code execution?
