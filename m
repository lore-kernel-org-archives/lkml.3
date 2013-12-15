Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3LOWJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 17:09:15 -0500
Received: from science.horizon.com ([71.41.210.146]:27935 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752011Ab3LOWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 17:09:14 -0500
Date: 15 Dec 2013 17:09:10 -0500
Message-ID: <20131215220910.24012.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, price@MIT.EDU, tytso@MIT.EDU
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20131215200312.GO27191@athena.dialup.mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My draft patch series uses Skein/Threefish.  The authors conveniently
> specified a way to use it as a PRNG, and it's very fast without
> special hardware support (consequently, for all kinds of hardware.)
> On my laptop, reading from /dev/urandom becomes about 25 times faster
> for large reads, and about 40% faster for small reads where the
> syscall overhead is more important.

Well, /dev/urandom is documented as being *deliberately* slow.  It's meant
only to produce 128 to 256 bits of seed material for CPRNG.  I don't
know if Ted considers speeding it up to be goal or an antigoal. :-)

One thing i've thought about is adding a /dev/frandom, which is seeded
once at open time and then produces a "reasonably strong" large block of
cryptographic output, very quickly.  (Key size between 128 and 192 bits.)

I understand why Ted didn't do this in the first place, but the number
of people I see doing something like "cat /dev/urandom > /dev/sdx"
to test incompressible data is remarkable.

If the additional code is small, perhaps it's worth doing.


BTW, if it helps on 32-bit platforms I can get you rotate constats for
a 32-bit version of threefish.  I haven't generated a key scheduling
constant, though.
