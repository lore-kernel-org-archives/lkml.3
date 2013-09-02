Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab3IBKiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:38:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39944 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3IBKit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:38:49 -0400
Date: Mon, 2 Sep 2013 11:38:43 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Ashish Chavan <ashish.chavan@kpitcummins.com>, lrg <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130902103843.GL3084@sirena.org.uk>
References: <1374482594.13726.11.camel@matrix>
 <20130722100211.GP9858@sirena.org.uk>
 <1375110386.21326.6.camel@matrix>
 <20130729160157.GZ9858@sirena.org.uk>
 <1375689331.28910.5.camel@matrix>
 <20130805144201.GF9858@sirena.org.uk>
 <1375717898.29528.23.camel@matrix>
 <20130805162342.GS9858@sirena.org.uk>
 <1377778108.15438.6.camel@matrix>
 <2E89032DDAA8B9408CB92943514A033751E611AF@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q8dntDJTu318bll0"
Content-Disposition: inline
In-Reply-To: <2E89032DDAA8B9408CB92943514A033751E611AF@SW-EX-MBX01.diasemi.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q8dntDJTu318bll0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 02, 2013 at 09:49:20AM +0000, Opensource [Adam Thomson] wrote:

Please fix your mailer to wrap within 80 columns, it makes your mails
very hard to read if you don't do this.

> At present I believe your suggestion is to instantiate the codec regmap in the MFD
> core for the PMIC, and then pass this in as part initialisation of the codec driver,
> from the PMIC. Please correct me if I'm wrong.

That's correct.

> If I'm correct then to me this doesn't make sense. The devices are separate,
> and have completely independent register maps. As such I believe the instantiation

They are not separate, they are soldered to the board as part of the
same package - quite a few other devices use a similar scheme and are
also handled in this fashion (the TI TWL devices are one example).

> 2) Including the above change, add some optional code to the PMIC MFD core which
> uses 'i2c_new_device()' to instantiate the codec, if it's required (I guess indicated by
> platform data to the PMIC). Means the Codec can still be used as is, but the PMIC core
> code can, if required, instantiate the codec.

This is roughly what ends up happening, you do need to instantiate
another I2C client no matter what.  The important thing here is that the
CODEC does not need to be separately registered by the user, if it
really is only the I2C client that needs creating that's probably OK so
long as the user doesn't need to worry about that implementation detail.

> I personally believe option 2 seems unnecessary and it would be simple enough
> just to instantiate the codec driver from machine code, as is done for many standalone
> codecs. Am interested though in understanding the reasoning behind your suggestion,
> for devices like this which are completely independent but can share the same HW
> package. I currently don't see a good reason to make PMIC MFD core instantiate the
> codec, for this type of scenario, but maybe you see something I don't?

The reasoning is simply that if the chip design solders a single device
to the board then the software system integration should register a
single device with the system.

--q8dntDJTu318bll0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJGqvAAoJELSic+t+oim9AyIP/1bOBVmht3EHdghQYFFqJmNP
LgTYuVJPn8CsAADaF8axnsYRMW6KbEXaeaiP+PSY4l3VsxeRRk17LPbfqI4JOAh1
ckKIneSOfxv6XgDyaFa3Q+yQkTfo1FbWxjpXDR0eMMFjwED9FtPgTJKPUcRYhgSV
PF9Cm94vYqf0ZZu4XeoSVpxUdX6OfKIS6pBWGQkUv9vi5KP/Ppt8jUSQl462+eC0
HbPciT+R6IaKpSbtD84p1W8+DL57dN1GMGi/owpbsFSbesakKewXUwy247OTUeof
XY0FvRMVX5EHDtNlAOa2sjCEsMukOsrN5Dd7I4Az/pfKAcehljGVZmELzF/rBvTt
tpf8CQwb+Y26YKMVcU1TCw4E08YSHh2r/TjCO9gQ2k+bhaUOdSlq9Rm2U7VFlAqS
DynxM3VlaGCt8KXGsIJR0DIWHjhc3jMEvMXePzSEdB9k5seW45ozK+tA0QCaZRNR
DlV4D8p0CWWbJBhayXHDmXX1GpFuEQ1GLuxSICeruGnnbbOvhUVjrMCcpAkpMAD3
9MfOcOgX2myLAbPRQUxXrD2Nb1vEXpb7SqZdQ60E1DIDbZ7dSQO9O2pJP0n/ji8m
NfHCDFn2lhaQ7CD9LTCE8O3rdFeUoprnSB5mfoNjQoW4KmzabLUTHPJI8d8fZTJO
qn/w4YhIoVF40zefocyX
=FyPC
-----END PGP SIGNATURE-----

--q8dntDJTu318bll0--
