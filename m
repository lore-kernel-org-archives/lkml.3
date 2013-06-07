Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3FGJEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:04:35 -0400
Received: from sauhun.de ([89.238.76.85]:50994 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab3FGJEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:04:31 -0400
Date: Fri, 7 Jun 2013 11:06:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] i2c: Let users disable "Probe an I2C bus for certain
 devices"
Message-ID: <20130607090623.GC3428@katana>
References: <1370367222-19353-1-git-send-email-grygorii.strashko@ti.com>
 <20130604174900.GA2992@katana>
 <51AF63C7.9070007@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <51AF63C7.9070007@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> 3) Thinking about Mainline: To reach the same target - no I2C
> detection - and taking
> into account above assumption "No changes in default behavior"
> the following will need to be done:
> - change i2c-omap/i2c-gpio DT bindings and add parameter which will
> allow to change
>   .class value for adapter. Not sure, it's possible because this parameter
>   will be Linux and not HW specific (smth. like "i2c_disable_detection")
> - update drivers i2c-omap/i2c-gpio to use "i2c_disable_detection"
> - update OMAP4/5 DTS files
>=20
> So, It seemed a good solution for me to add 6 lines of code in i2c-core.c
> instead of doing all that stuff.

Well... I understand the "default behaviour" issue, yet I still think
that setting class to 0 is the right thing to do. OMAP is an embedded
SoC which always had i2c_board_info or devictree which are the preferred
ways of instantiating. Given that, I would accept a patch setting it to
0. The more user friendly way might be to introduce a new class which
makes users aware of the issue. Proof of concept follows, only compile
tested.


--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRsaKPAAoJEBQN5MwUoCm2QpYP/jD5ltUb6TztwZcMtJ6k7kRc
7RQN+trAbEhD7YmiwOa/6Ud24ea9wuC8oFW7Cg8U5sGlehBe728T8Zo84gz5Qecn
SdYv5Xw7FXJhmEA2mK/WAtsdLC8hgACaduDtMAhYO9DQ7xWlxuuQP/RKjm/AYp64
LOeKVUPuLF07e4yiXl/KuIDczYwzdl8l81VPLhmQdnF+OyHgJ5o1yGGYBQ6Kk22I
Dp2CeNNHIFlEIzE9aOikzfv/lGdbLTwmJURzNAEMHKMEZFWYPknb/DUxzp74xJLW
Xwmbg2uf4hV3msTeWIvIbZV5XMI5D9nHoJYvvPEQoTIsyiUO4jODQq1rq0v55Ya0
d1gGWwfvEjWq0UOzyMGkDPgM7P767xn8rzMuzN2uUqx2Y3uye7XyARDVzwg2fCiH
nIC7+4DD+JQMB0bR1VYVcJnlfWY9cvk/acweQYTgUz4BDn++gpqf/26VC0296Iz+
ZayUNBMKBp7mCOPu0uHgltVujnILBPVbd11CzjUdIZN899xPGWQTZlDi8cpWxxXb
N8ZBBnC2LBYnCxmJHurdP3lHazcDiU4EKcRecSx9sNhknALIvtdk51wWT67Fa2pi
P1+lXbjh+tMqSEw2iIHfqDCWSQG2hrUcqGJBxv22DiMPm/UrqTkdzfXMovhwVbY9
7qHgRyfWKX+A1nfTWowk
=wYPj
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
