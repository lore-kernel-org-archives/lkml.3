Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaJPJ60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:58:26 -0400
Received: from sauhun.de ([89.238.76.85]:45341 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaJPJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:58:24 -0400
Date: Thu, 16 Oct 2014 11:59:10 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <andreas.werner@men.de>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, johannes.thumshirn@men.de
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141016095910.GC1273@katana>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
 <20141016085835.GA1273@katana>
 <20141016102126.GB23256@awelinux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <20141016102126.GB23256@awelinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I do not want to parse the things in userspace because this EEPROM data
> are related to the hardware and i want to give our customer the easiest w=
ay
> to access the data without installing any tool.

I understand that point of view. From an upstream point of view, things
may look different, though.

> The current state to read the eeprom data is, that customer needs to inst=
all a big
> environment where the tool is integrated to have access to those kind of =
simple
> data or they have to write their own code.

i2cget from i2c-tools? You could do a simple shell script to parse the
data. Or do a board specific hook which reads the data and prints it to
the logfiles...

> > Consider how bloated the sysfs-ABI might get if every vendor who uses an
> > eeprom wants to expose the data this way?
> >=20
>=20
> Yes and no. The possible sysfs entries gets bloated if every vendor will =
do it
> like this way, but normally there is just one Board EEPROM on the board, =
therefore
> only one driver gets loaded.

I am not talking about runtime here, I don't care about that. I am
talking about the ABI we create and we have to maintain basically
forever. And with vendor specific configuartion data I have doubts with
that being stable.

> I mean its the same for every i2c device like a temperature sensor, I can=
 also
> read it from userspace without any special hwmon driver.

These is a HUGE difference. If I read tempX_input, I don't need to care
if the sensor is I2C or SPI or whatever. The kernel abstracts that away.
The files you create are for your I2C EEPROM only. Data gets
"reformatted" and access gets hidden, but nothing is abstracted away.
It would be different if we had a generic convention for "serial_id" or
stuff like that. But as configuration data is highly specific I don't
see this coming.


--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUP5buAAoJEBQN5MwUoCm22vIP/RdD8wIVSxhDA5dv+qpizBG4
RR1xbeTCirzJQ8ZZNWGVK8JB/hcO4kEztlZSpGCXK09VqNk39kiOi1i7b3IxQbyE
4sOWk5r8tdKtO4wwJs6Mi5Z3Q+MHHx9Gj4sSIg3Tepk/bW9b6JLXRVZTwuIbfNnX
6TUZdIMN5L2YRRMTf0pMximA8FUu6++WXW6EDBji8lSbklU8gGqkMALQikeBq668
+ZVpTcB5tyq7gPMC+EyH7irLaRZGOOIuoZ0zlI01HRfDZOTzCpcvlsZFmq/gCN36
p1/3NsHYzfR0ICAJKn1rx7i9N2o/xXxkxjgtbd/d4/KIQKmqOemJEYvi6wiXCpxg
NQSoxVt9/pR0ebqGqnyacffS3V84gJMKonoyrjtvXilh1t38nENwuO58IxnqWKiL
l3TzlusffOckd9vYvMmmGMBIV60vx96nXmkmZRC8wkN3nmVDi/lFu4thkueMyJiQ
cL/ZDErm7CjqPxtCMDK9zA5EOAXuOtunw4llZYQAC/1pXRPcWL01LFW4YqJ+6qP8
CL8iXsMvgMOTosA5OIzfxaTSdZxWMDEVkwHMRCA74AFch3/3TESvPiPU5xhxwu4U
j/vwjiDY1IDfNLUq93xbDsQz6P5EOCCVZhj9r8FE34r7GprmS1fLRDXHA3EhGI2t
S+SFlV2lobjF173y/kt2
=fQiZ
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
