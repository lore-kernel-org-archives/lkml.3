Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3G3UpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:45:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51885 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab3G3UpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:45:20 -0400
Date: Tue, 30 Jul 2013 21:45:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130730204511.GX9858@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
 <51F7FBA8.6080400@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o9CSdzDyaZ/W953l"
Content-Disposition: inline
In-Reply-To: <51F7FBA8.6080400@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731
 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o9CSdzDyaZ/W953l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 11:45:12AM -0600, Stephen Warren wrote:
> On 07/30/2013 04:32 AM, Richard Genoud wrote:

> > +wm8731 pins:
> > +cf Documentation/devicetree/bindings/sound/wm8731.txt

> In the Tegra bindings, I deliberately put the list of CODEC pins into
> the audio complex binding rather than the CODEC binding. That's because

You really shouldn't do this, it's not accomplishing much.

> I'm not sure that in the long-term we want to use strings to identify
> the CODEC pins, rather than using integers. By putting the list orf
> CODEC pins in the audio complex binding rather than the CODEC binding, I
> didn't lumber the CODEC binding with a list of strings that it had to
> support forever.

How would you create the numbers - you can't use the pin numbers since
BGA type packages have alphanumeric ball identifiers?  Even with
numerical pin numbering ou'd need to specify some defines for this not
to be totally awful at which point you may as well have the strings
documented since you'd end up writing a table in the binding document
that's basically a mapping of pin names to numbers,

> One reason that strings are problematic is because they can't be mixed
> with integers/phandles in the same property, so if we ever end up with
> more generic audio bindings where the routing table is expressed more like:

> audio-routes = <&component_a $a_pin &component_b $b_pin>;

> ... in order to allow completely arbitrary and fully name-spaced routing
> specification[1], then $a_pin and $b_pin need to be integers not strings.

The above is going to be legibility challenged without defines at which
point the strings end up appearing in the binding document anyway.

Besides, you're stuck with the names you picked anyway so you may as
well put them in the CODEC driver binding document so that anyone else
using the same CODEC can reuse that bit of work.

> [1] and perhaps we can get rid of properties like
> audio-codec/ssc-controller, and automatically deduce which components
> are needed simply by finding all phandles in the audio-routes property.

> Perhaps the solution here is to allow mixing phandles/integers/strings
> in one property, but that's potentially quite a large change to the DTB
> format; we'd need to introduce type fields into the property data, and
> other data format changes.

I really do think this is a DT failure which ought to be addressed
there; people are working around this with things like parallel arrays
with names and phandles which aren't awesome once the arrays get to be
any size.

One option that seems sensible is to introduce syntactic sugar which
will do the parallel arrays trick automatically - the actual DT that
gets output could still be two arrays with indexes that match up (so no
impact on parsers) but the DT author would be able to write an array of
(phandle, string) tuples or something instead of having to line up two
arrays.

--o9CSdzDyaZ/W953l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+CXTAAoJELSic+t+oim9LH4QAJV5p0kISb3fr7KlQSJdGr3p
qWas0NliPSCsfKHlPkHM7gG313DhQygLX0ObB4gG9aWfGxHwzlCux4SfzaK4MStF
dwU3NOXyY7Pu/p/vLK7zISRWLHqwBVT47ZXZJqQSFT6mw2wrIu+n1oR0yZ7iWRNu
GIqf9QBzwOkuztonOdBhL6pssGkCruN6g2U/6MCbthNrqYweyAnJw9g22wjGFCWP
aS1JBtJGHqTa6mmkgi7NwE0m2c5MzrfaZLNaSZYfcF2EslNMg6oDehjZRrIm8c6n
ZDOR8md9GT/NdR+WELWIyL1THDc1mQ7Ez/T3fTJiCgP4WK0yztoprGeounB3vMv7
WqfOv0RspOv3ndWWoBEbjHgNbw9yBm5IZETEiBAREtmLVk82DYykvWqN0Tm0QOUT
dIJMTw1pyxJKFiZIX38BdEK1qPZmOBKcEsbPAOzztf98P6YgrB/JVaWkI87ZFdTM
5zGXikai/Bxptdj0RtYEReySDtHY76qyy1FkGMiUnckvMMvL/+x+hTpLuqjKOgRQ
dMJHNcUu/rxXIrPZ2KW08m0+OBcj5R4rBrUTY7Rrx/hhM2ZezRnQaLYx67xw1aAv
nPogz0zeEMuVjJVf3cyWRBi6htz/zXtwRuxeJcA3I2KxND9PnSSxKOnx4CKRaJ+4
wJvIipG/9uGELfsIloRO
=CEfL
-----END PGP SIGNATURE-----

--o9CSdzDyaZ/W953l--
