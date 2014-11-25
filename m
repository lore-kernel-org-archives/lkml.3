Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaKYW2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:28:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38733 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaKYW2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:28:03 -0500
Date: Tue, 25 Nov 2014 22:25:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-spi@vger.kernel.org, Andrey Yurovsky <yurovsky@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20141125222556.GA7712@sirena.org.uk>
References: <1416853893-1993-1-git-send-email-andrew.smirnov@gmail.com>
 <20141125124229.GY7712@sirena.org.uk>
 <CAHQ1cqGvDft1t5MkaqT-xsfBygdghA3mK_a7x+Z3L6HtvqrwhA@mail.gmail.com>
 <20141125134048.GE7712@sirena.org.uk>
 <CAHQ1cqHSdV4XTxwnPYfdBK8mVYQk9O3akynSM_hUGmVDMRU3FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kE3bP8KkoMMpyhFK"
Content-Disposition: inline
In-Reply-To: <CAHQ1cqHSdV4XTxwnPYfdBK8mVYQk9O3akynSM_hUGmVDMRU3FA@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC, PATCH, RESEND] spi, spidev: Add support for long SPI
 transfers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kE3bP8KkoMMpyhFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 01:18:45PM -0800, Andrey Smirnov wrote:

> >> in my wording of the summary and not use the word "transfer" anywhere,
> >> but it looks like I slipped twice and that might have contributed to
> >> this confusion. I apologize for this and hope that my comments
> >> clarified my meaning/intent

> > Sorry it's still not at all clear, please re-read what I wrote about
> > what bits_per_word means since I really don't think you've understood
> > what it's for.

> OK, I think I use too generic terms and descriptions and maybe that's
> why it is not very clear what I mean. Just to give more context I am
> working with i.MX6 SPI peripheral, and AFAIK I have two options of
> using it:

Ah, i.MX...  When I've worked with it I managed the chip select with
GPIO since it was flipping the chip select per word.

> - Use a generic GPIO as SS/CS. This way everything works exactly as
> you describe, but unfortunately using GPIO leads to a significant
> overhead for SS/CS assertion/deassertion.

It's really surprising that it's expensive to use a GPIO, I've not seen
other users complaining about that.  Do we understand why (I'm guessing
you have some extremely performance sensitive application here so you're
just more picky than most)?

> - Use hardware controlled SS/CS in which case peripheral toggles the
> line every "burst" it transmits, "burst" is n bits where n can be from
> 1 to 2^12
>  For 1 <= n <= 32, and software SS/CS the concept of a "burst" matches
> the meaning of "bits_per_word" field and this is exactly how it is
> setup in the driver.

But if we go over 32 bits it doesn't do the byte swapping?  Hardware
designers are wonderful, creative people sometimes.  In general this
isn't going to be sufficient for all transfers even with the non swapped
case since it means we can't do more than one transfer per message
unless we start coalescing in the core and putting in dummies for cases
where transfers change (we should do these things, they're a win in
general since we can just set the message up and let the hardware do the
transfer, but it's not completely trivial).

> So with all of this in mind what I am trying to achive is to have
> longest transaction with minimal CS/SS switching overhead. The change
> in my patch allows me to set the length of a burst to its limit.

The driver should probably just be doing that where it can, it seems
like the burst size should be based on the transfer length not the word
size - we might need to just manually mangle the data for short
transfers.

The *easiest* thing would be to manage as a GPIO, though - it's normally
fast enough.  Some more information about your application might help -
what sort of transfers is it doing for example?

--kE3bP8KkoMMpyhFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdQHzAAoJECTWi3JdVIfQ9KAH/3d3Mf1j2E7fKxc6fmjm64hq
8lWnwEY20IwRtZUR8xmDbjdGrXrWej8x8i+6CZqgMwA2fKVrWdn1awRK/DnGGBWF
Bofxmz95LBwHxlnPgpM52J+bhRLaoQiLIw+W9yh/NhgXRZ8cZsEIxpEl2gwevLiX
71GxDhwx4XHXfZozz8lrUIEPC6EueCw1MUBEyeM9uTM+vrO0rzLxYOzIZWx2aek9
7+IOZVr10WNRsQ0Jb04GikqzgUMg3B71bSTV08tntZ36Uu+eGqrzmdkc9+ROXqe+
TIHPbH7YgXikT8anP9s/OJFf9f90i0OXjWKIy4HfPGG0KNmxMR2rx2IsJDxB9uA=
=cCZP
-----END PGP SIGNATURE-----

--kE3bP8KkoMMpyhFK--
