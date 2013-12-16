Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3LPGxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:53:11 -0500
Received: from science.horizon.com ([71.41.210.146]:31024 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751858Ab3LPGxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:53:09 -0500
Date: 16 Dec 2013 01:53:07 -0500
Message-ID: <20131216065307.30752.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, price@MIT.EDU
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux-kernel@vger.kernel.org, tytso@MIT.EDU
In-Reply-To: <20131216003253.GC7790@athena.dialup.mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Well, /dev/urandom is documented as being *deliberately* slow.

> Hmm, I don't think I've seen that documentation.  I don't see anything
> about that point in the comments of drivers/char/random.c.  The
> urandom(4) man page says /dev/urandom "is designed for security, not
> speed, and is poorly suited to generating large amounts of random
> data."  Which is quite different from being designed for slowness!

I guess the comment has evaporated.  I know it used to be there,
either in the source or old mailing list discussion.  However,
it's almost 20 years old now and I'm having a hard time tracking
down a source.

The comment wasn't, as the trailing :-) indicated, entirely serious.
There's no actual *problem* with making it faster, but I remember Ted
being very clear that he actually wanted to *discourage* people from
reading lots of data from it.

That's what I was alluding to.

> The great thing about the state of cryptography in 2013 is that we
> don't have the kind of tradeoff between speed and security that we had
> in the past.

Absolutely.  No argument.

>> BTW, if it helps on 32-bit platforms I can get you rotate constats for
>> a 32-bit version of threefish.  I haven't generated a key scheduling
>> constant, though.

> I wouldn't want to compromise on security to do it, though.  My
> confidence in Skein/Threefish's security comes mostly from the SHA-3
> competition, where many expert cryptanalysts attacked it and didn't
> get very far except in understanding why it seems to be hard to break.
> To make, or even evaluate, a 32-bit variant of Threefish seems like
> it'd require much deeper understanding of the design of Threefish and
> its cryptanalysis than I've tried to develop.  How do you plan to
> evaluate the security of your 32-bit Threefish?

The designers posted the search program they used to generate the rotation
constants, as part of proving there are no back doors.  They say in the
paper that a 32-bit version is possible, although they didn't generate
rotation constants.

Porting the program to 32 bits is a bit of a pain, as 64-bit assumptions
crept in all over, but it's not that hard.

As was pointed out in the competition, an attack on *any* fairly-random
set of threefish rotation constants would be alarming.  The set that was
chosen uses general principles for making a good choice, but if there
is some non-obvious criterion that can create a significant weakness,
that would be a major problem for the entire ARX structure.
