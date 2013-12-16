Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3LPPDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:03:18 -0500
Received: from science.horizon.com ([71.41.210.146]:37930 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753755Ab3LPPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:03:17 -0500
Date: 16 Dec 2013 10:03:15 -0500
Message-ID: <20131216150315.4746.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux-kernel@vger.kernel.org, price@mit.edu
In-Reply-To: <20131216064359.GB28544@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I understand that; and as I wrote in my last e-mail, I think that is a
> substantially harder attack than the currently published cache timing
> attacks, which are chosen plaintext attacks --- that is the attacker
> doesn't know the key, but can choose the plaintext, and view the
> resulting ciphertext.

Okay, sorry for the misunderstanding.  I *thought* we were talking past
each other.

First of all, you might want to look at this paper:
http://www.ieee-security.org/TC/SP2011/PAPERS/2011/paper031.pdf
"Cache Games -- Bringing Access-Based Cache Attacks on AES to Practice"

It describes a practical implementation of a timing-based key-recovery
attack *without any access to plain- or ciphertext at all* after watching
~100 block encryptions in OpenSSL.

Key recovery is the target usually studied, so recovering the text
(in the absence of the key or other text) is not as well documented,
but it certainly shouldn't be any harder.

The major complicating factor is that most attacks assume a constant key,
while hashing uses a varying key per encryption.  But there are strong
dependencies (the output of one encryption is the input to the next)
that can perhaps be handled with improved analysis.

No, I don't have example code, but I hope you can see how I think
concerns are realistic.  (And remember: attacks only ever get better.)

(I should also mention that the paper above exploits the Linux scheduler
to collect high-resolution timing information, so could be greatly
hampered by disabling preemption in /dev/random.  But there is probably
an equivalent attack via hyperthreading.)


As I've said before, the point I want to stress is not even that the
attack is necessarily practical, but it's a PITA to prove that it's *not*,
and the SHA-3 competition has given us several excellent cryptographic
cores explicitly designed to avoid the issue entirely.

If the alternatives to AES had serious disadvantages, I'd be getting busy
with a detailed comparison.  But is that even necessary?
