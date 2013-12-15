Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3LOWTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 17:19:53 -0500
Received: from imap.thunk.org ([74.207.234.97]:40258 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3LOWTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 17:19:52 -0500
Date: Sun, 15 Dec 2013 17:19:48 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Message-ID: <20131215221948.GA6773@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
References: <20131215022147.GA24124@thunk.org>
 <20131215083459.22068.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215083459.22068.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 03:34:59AM -0500, George Spelvin wrote:
> > I'm not convinced we need to worry about cache timing attacks, since
> > they typically involve a chosen plaintext attack and a fixed key ---
> > and the attacker isn't going to know what we are going to be
> > encrypting, let alone be able to chose the plaintext.
> 
> You're describing standard key-recovery attacks.  For /dev/random,
> just knowing the *ciphertext* constitutes a successful attack.

Um, no.  The *ciphertext* is the output.  The attacker can get all of
the ciphertext he or she wants by reading /dev/random (although we'd
probably do some folding as we currently do so the attacker won't even
get all of the ciphertext).  What the attacker has to be able to do is
given some of the ciphertext bits, be able to predict future
ciphertext bits given some construction which uses AES as the basis.

For example, using something simple (we'd probably using something
more complicated, such as Davies-Meyer), show me a cache timing attack
where the attacker can get to see arbitrary values of:

      R_X = AES(KEY, I+X)

But where the attacker does not know KEY, *or* I, but can get to see
R_X for values 0 < X < N.  The attacker has to be able to predict
R_(N+1).

Show me a cache timing attack given this scenario, and I'll be
convinced.  I believe this is **harder** than a standard key-recovery
attack, since the attacker doesn't get to choose the plaintext.  And
if you can't choose the plaintext in order try to recover the key,
please tell me how use can use cache timings in order to predict
R_(N+1), or even some bits of R_(N+1)?  Especially given that any good
crypto algorithm is designed so that even one or two bits change in
the key or the plaintext will result in massive changes in the
ciphertext....

					- Ted
