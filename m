Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3LOCV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:21:56 -0500
Received: from imap.thunk.org ([74.207.234.97]:40069 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460Ab3LOCVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:21:54 -0500
Date: Sat, 14 Dec 2013 21:21:47 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Message-ID: <20131215022147.GA24124@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
References: <20131214192307.GA10457@thunk.org>
 <20131214215559.10128.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214215559.10128.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 04:55:59PM -0500, George Spelvin wrote:
> 
> What's critical for the input hash is that seed additions don't cancel
> each other.  That is, XORing in some new seed material doesn't hit
> the same bits as older seed material.  What's key is not exactly that
> additions affect lots of bits as that *different* additions affect
> *different* groups of bits.  In other words, differentials rather than
> single-bit avalanches,

Agreed, but that's we have the input_rotate.  Do you have analysis or
arguments why we Richard Brent's construction would do a better job?

BTW, one other design requirement I had when desining the mixing
function was if you fix in all zero's, the result was a reversible
mixing of the bits; in other words, "dd if=/dev/zero of=/dev/random"
is guaranteed to not lose any entropy caused by self-cancellation.

> The SHA-3 competition has given us lots of random permutations and
> random functions.  Keccak, Salsa20/ChaCha, Skein/Threefish and SipHash
> are all interesting looking.  AES/Rijndael is actually less so, unless
> you're planning on using hardware support, because of cache timing
> attacks on the lookup tables it needs for software implementation.

I'm not convinced we need to worry about cache timing attacks, since
they typically involve a chosen plaintext attack and a fixed key ---
and the attacker isn't going to know what we are going to be
encrypting, let alone be able to chose the plaintext.  Even if that
were not the case, see the paper, "Are AES x86 Cache Timing Attacks
Still Feasible?":

	http://cseweb.ucsd.edu/~hovav/dist/aes_cache.pdf

Regards,

						- Ted
