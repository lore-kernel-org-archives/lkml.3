Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3LPGoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:44:05 -0500
Received: from imap.thunk.org ([74.207.234.97]:40419 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3LPGoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:44:03 -0500
Date: Mon, 16 Dec 2013 01:43:59 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Message-ID: <20131216064359.GB28544@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
References: <20131215221948.GA6773@thunk.org>
 <20131216042247.9826.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216042247.9826.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 11:22:47PM -0500, George Spelvin wrote:
> 
> > Um, no.  The *ciphertext* is the output.  The attacker can get all of
> > the ciphertext he or she wants by reading /dev/random (although we'd
> > probably do some folding as we currently do so the attacker won't even
> > get all of the ciphertext).  What the attacker has to be able to do is
> > given some of the ciphertext bits, be able to predict future
> > ciphertext bits given some construction which uses AES as the basis.
> 
> The attack I was thinking of was figuring out (without breaking root and
> using ptrace) what some *other* process on the same machine is reading
> from /dev/random.
> 
> In other words, reading someone else's output.

I understand that; and as I wrote in my last e-mail, I think that is a
substantially harder attack than the currently published cache timing
attacks, which are known plaintext attacks --- that is the attacker
doesn't know the key, but can choose the plaintext, and view the
resulting ciphertext.

In this case, the attacker doen't know the key *and* the plaintext; it
can view its own attempt to read from /dev/random, but from that, it
needs to be able to figure out the the key and the plaintext (i.e.,
the entropy pool) in order to be able to predict someone else's output
of /dev/random.

If you think this is easier than the currently published cache timing
attacks, please provide details why you think this is the case,
preferably in the form of a demonstration....

						- Ted

