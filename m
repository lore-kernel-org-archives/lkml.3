Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaLRPJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:09:22 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:60246 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaLRPJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:09:21 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
In-Reply-To: Your message of "Thu, 18 Dec 2014 12:08:58 +0100."
             <201412181208.58969@pali>
From: Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412101251.30610@pali> <1420702.eyL56f8lc9@xps13>
            <201412181208.58969@pali>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418915331_3791P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 10:08:51 -0500
Message-ID: <21066.1418915331@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418915331_3791P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Dec 2014 12:08:58 +0100, Pali Roh=E1r said:

> So your BIOS cannot report nominal_rpm and because your machine=3D20
> is not in dmi list, all 3 patches do nothing for your machine.
>=20
> But you need to set multiplier to 1, right?
>=20
> What about this patch? (on top of 3/3)
>=20
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> =40=40 -850,6 +850,10 =40=40 static int __init i8k_probe(void)
>  		 */
>  		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan) =7B
>  			i8k_fan_mult=5Bfan=5D =3D I8K_FAN_DEFAULT_MULT;
> +			if (i8k_get_fan_rpm(fan) > I8K_FAN_MAX_RPM) =7B
> +				i8k_fan_mult=5Bfan=5D =3D 1;
> +				continue;
> +			=7D
>  			for (val =3D 0; val < 256; ++val) =7B


Dell Latitude E6530, linux-next 20141208 plus the 3 patches you
posted on Nov 30 (support labels), plus the 4 of 3 patches in
this go around, and sensors reports:

i8k-virtual-0
Adapter: Virtual device
fan2:        2774 RPM

and under CPU load, that number rises to 3200 or so, so it seems to be
working....

So you probably should fold this into the current set of patches, and
feel free to put this in there:

Tested-By: Valdis Kletnieks <valdis.kletnieks=40vt.edu>

--==_Exmh_1418915331_3791P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJLuAwdmEQWDXROgAQJ7yA/9Gdym1B0TIA9pfBXqaaoJdZ86EXZCdfLA
uHvXnZb6V2/fYPamF2XYfBB0cUAu5K/T9yvZ1TqdHPTCAKM8t+6+YfQ7l54hkdET
Kakew2rwgwtZF2ZhXjCPZjrRe+iXb6U+2eyHf3sJ99HBG2a3wcyvEpvWwTlbnmuO
QJdTCsv4zTvM5FNtubZPOejteN5xC3dmrymIP788uwryUW0mVNq74V/lrZDnG3Yq
6Cj5LZINAsU9Ems0KyU6JWJ3ivAQ2MKoLFn95dDRhvPgf5G9Lxla1Ccs8sZcB4Et
njzvzLxffw/NqpbhkkbkHWqKgtGR8gJV4ZS/OA7h7IHMkQhgtfakbhIupnv9qz+y
C8gfflFrI2lHUT9kQjBP15ZiMy83TOBWf9um9RHJgsHctfVNiF1QocoFXBkswFec
iLHG/7UJMwwBFgYQw46g1stIZu56j7xwNsf3EjsOrYqd+TtjuZdXhUvDBPxu1s/1
uXljRL2suMMLMIX2z8vPNz36FvJCX2f9PRgePl4hEIgly+7kO4WoZexvDH6hOsF9
2FRaK79+frFBOnKTp76B/5Cx/Ko623ZKvhl10aYDGrTWyV/o4CL35nySpbUOGKpe
B6hKlXscGSXnhdd4VAvg0H+fbz3L854M8QU+MS3FzprwqBb+UTrqq1W3fc7Pw/qt
8S73Ru3nkUE=
=DcVx
-----END PGP SIGNATURE-----

--==_Exmh_1418915331_3791P--
