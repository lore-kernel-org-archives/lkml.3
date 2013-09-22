Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3IVXX6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 19:23:58 -0400
Received: from imap.thunk.org ([74.207.234.97]:36118 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3IVXX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 19:23:57 -0400
Date: Sun, 22 Sep 2013 19:23:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH, RFC 10/12] random: cap the rate which the /dev/urandom
 pool gets reseeded
Message-ID: <20130922232337.GD7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
	dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
	smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
 <1379882338-7209-11-git-send-email-tytso@mit.edu>
 <e665f20c-9154-4dbd-bb93-cf144922bf29@email.android.com>
 <20130922214039.GC7321@thunk.org>
 <a3890544-745e-462d-8647-68c5abf78e9e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3890544-745e-462d-8647-68c5abf78e9e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 03:45:11PM -0700, H. Peter Anvin wrote:
> I understand the motivation, but I question basing it in a fixed amount of time.

We already have a threshold based on the amount of the entropy in the
input pool.  I could increase that threshold, but then instead of
having the entropy hover between say, 192 and 128, it would hover
between say, 576 and 512.  What that means in practice is that there
will be a higher baseline, but we will still end up reseeding every 10
seconds or so (that being approximately how much entropy I've seen
flowing into the input pool on my laptop system --- 64 bits every 10
seconds or so).

By basing it on a time-based threshold, it means that the input pool
can build up faster such that over time, such that entropy pool ends
up hovering around 3400 bits.

What is your concern is about having it being time-based --- or more
accurately, being partially time-based, since we also keep the entorpy
count based threshold?  I'll note that the Fortuna Random Number
Generator, devised by Bruce Schneier and Niels Ferguson also uses as
part of its design a time-based reseed limit.

						- Ted
