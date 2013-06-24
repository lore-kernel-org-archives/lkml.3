Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3FXKPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:15:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50699 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3FXKPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:15:03 -0400
Date: Mon, 24 Jun 2013 11:14:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, lgirdwood@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yizhang@marvell.com
Message-ID: <20130624101454.GG27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
 <20130621152416.GC27646@sirena.org.uk>
 <CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bfHXWC0AWsk5KHuB"
Content-Disposition: inline
In-Reply-To: <CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bfHXWC0AWsk5KHuB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 10:01:39AM +0800, Chao Xie wrote:
> On Fri, Jun 21, 2013 at 11:24 PM, Mark Brown <broonie@kernel.org> wrote:

> > Just provide get_voltage_sel(), the core will do the mapping to voltages
> > using list_voltage().

> I am a little confused.
> The BUCK voltage is not linear, and it contains a lot of voltages.
> If we use map_voltage_ascend, it will looking a a suitable voltage
> from begin to end one by one.

What does this have to do with get_voltage()?  And note that you can
write your own mapping function for a reason...

> If we directly make use of set_voltage and get_voltage, we can
> directly calculates the voltage which is
> suitable, and do not go through all the voltags.
> for example, now BUCK voltage table is
> range 1 from 600000 to 1587500, each step is 12500
> range 2 from 1600000 to 1800000, each step is 50000

No, this is nothing at all to do with using the selector versions of the
API.  Think about what the API is doing and take a look at the code.

> >> +     } else if (pdata->num_regulators) {
> >> +             /* Check whether num_regulator is valid. */
> >> +             unsigned int count = 0;
> >> +             for (i = 0; pdata->regulators[i]; i++)
> >> +                     count++;
> >> +             if (count != pdata->num_regulators)
> >> +                     return -EINVAL;

> > This looks...  odd.

> It is just make sure that pdata has correct number of regulators.
> It you think that it is redundant, i can remove it.

If you really need to have platform data for all the regulators then
just embed the array inside the platform data so there's no possibility
of any confusion.

> > With deferred probing you should just be able to use
> > module_platform_driver().

> The regulator controlles some BUCK regulators.
> These regulators may be used by application CPU or CP(communication
> CPU) for telephony.
> The CP may need different voltages if it goes deep initialization. if
> we defer the setting later, it is too late for
> CP initialization, and will impact the performance.

If your kernel startup is taking long enough for this to be an issue it
seems like there's much bigger problems here and things are going to be
very fragile anyway, it's going to be better to figure out what the root
issue is.

--bfHXWC0AWsk5KHuB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyBwbAAoJELSic+t+oim9Q+wP/3BfDy7aGY8qrOIHBnY7Glec
lhZo6vPobMF1Pzbi5vxLd0nmnGqbzrHOfu2I2XcepjTKBTVVoNwL8nE0372t5Xop
YRJOlvZ0I2tXAE7HtpFA3Tem1OOOprCpJ3TTQvtGla4RJrcid1B+h5GsWSHAb8l5
KhpQ9ZRrSdV42gufFu7ay9+H7YfkwylRwFXxqkxY5anukBnOVJkkyIs7p1AkTW1f
DGiZYfNRjZZ6shisW6nYffdC+veMq5bHeuRAYq+x+p0ibaBDS8/JdPDAjKlfZhxO
dW8ThFKkN4ldW6cEH0doYGh2rXWRc0ECdky2qtl4wV24LYxtfYV2RBMK/Rv1RFEC
bXpGs0xQb46f6CKKiNUF5IWi+88fa1CWK2Z1Yhreh/L2mV0nBIf6aZRKxPlmL8w2
pEPNlSrmkO5lHc/v9qOPGW896c4ZszZAcRTO0plfU3B7JolMjkV0yM6f/dcKh7sf
+z2jcQN0JuX9nSJfuuxGRpBOsl5++TxaF9A+DIu1RSC70jmPz3hhO+X9xMb2m1B5
PeHPw1utTZhS06Uv87ElHo2s16PRW2o8xrhJo+juglGF4TzDsx0emLF7LYYyUD1L
K5auaMf63hmgWVDO9h+0qxBc3pP+/QB1wSCNDpnC4XVAAWMS9Uz3KtrGveJa/HX6
j2JW79mK2CHcwaIlKvcb
=82X+
-----END PGP SIGNATURE-----

--bfHXWC0AWsk5KHuB--
