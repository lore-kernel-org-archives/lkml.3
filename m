Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbaFJIT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:19:58 -0400
Received: from sauhun.de ([89.238.76.85]:33466 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbaFJITz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:19:55 -0400
Date: Tue, 10 Jun 2014 10:19:50 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v4] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Message-ID: <20140610081950.GA2620@katana>
References: <5192968.EzcUiXba22@typ>
 <1547619.upPdAXDT0W@typ>
 <20140602120854.GA2654@katana>
 <1468105.xYIQWVNzVZ@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1468105.xYIQWVNzVZ@typ>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > +	/* Synchronization & notification */
> > > +	spinlock_t lock;
> >=20
> > Why the lock? The core has per-adapter locks anyhow.
>=20
> I'm using it to lock the rk3x_i2c struct during interrupts. It's needed t=
here=20
> because an operation can timeout, which means the interrupt can occur at =
any=20
> time and possibly conflict with the cleanup I do after a timeout.
>=20
> I looked around in i2c-exynos5.c, i2c-pxa.c and others, and they do it th=
e=20
> same way. Could you explain in more detail why it's not needed?

I saw that you disable IRQs on timeout, so that shouldn't happen? You
don't disable IRQs after a successful transfer, though, AFAICS.

> > It looks to me that you STOP after every message? You should use
> > REPEATED_START inbetween messages and only stop after the last message
> > of a transfer.
>=20
> I had a fight with the hw today and finally got it to issue a REPEATED_ST=
ART=20
> for multiple "boring" messages. Will be included in the next version.

Great.

> Actually, I wasn't aware that (len =3D=3D 0) is a valid case. The hw supp=
orts it=20
> in both modes, I just tested that. So the check is going away.

Also good!


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlr+mAAoJEBQN5MwUoCm2E38QAIc0r1TB/LiT/wQnX8dUL+TC
vWEM0bpIm5CIaHnrS08HbAflht0ZfLB0zqXnDbfylYLzO1a8fPary5wDVFRUq2Z7
oCYx4mpKscRnInrozhrDVPgu0WaVRunPn4XzixEoNqo/EK0/jXfT+gDosm8eQwBU
HkjV4cPdflzwmw6MkVu0pa9+ojEY/qa9jY4z67OQICvAor58JwXjAzhXkz7o9C5U
dMmRFMUVxc60ukRx4BzlT8sqzdVc8n2bmdWtJxkibtObHDH/xfZK9UCkYunPwG3H
HuvoFj73siBNe3Ukjk5k3yWBWUECE2TzMidyXU8bz0sxR4pWYfD8NOIlr8stecHD
Ulc1iGzNvgZJ6NRZ4hw40lo0Nrb5XsrSbMp9TOptzNa5+kbmxT0Q+gnHAzqr9KQW
j769QJ247gubRnFagbUPiSR3G5Q1vM51OT5Iye87fZ9D4ews2yxO4prVMCyT0zyy
D3HVx6qLwB5S3XT87aivkXYBc4dtTHmpWus08RUDmtRndN8HJdISy2RXjZYXrxoE
7DeF9dqaepMNpDSs2Xmeaq8gJca+D/EXb/XyAB3kC/M3I3Dd1EDXEaRAgxX/3iGt
MwdaYjvJrcR94/mRc4sCfONdD+Wk9s9Qz4BDbHb/riGwfHeYppqFl3IzSLxXRhEc
jAEwTAcGewT4mjs9Gyws
=pzGX
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
