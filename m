Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935207Ab3FSU4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:56:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54815 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab3FSU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:56:12 -0400
Date: Wed, 19 Jun 2013 23:56:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: <balbi@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 1/5] i2c: omap: fix spurious IRQs: disable/enable IRQ at
 INTC when idle
Message-ID: <20130619205607.GB6804@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-2-git-send-email-grygorii.strashko@ti.com>
 <87li6llk4w.fsf@linaro.org>
 <51C1F9FA.9000502@ti.com>
 <20130619193111.GD4779@arwen.pp.htv.fi>
 <878v257tuv.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <878v257tuv.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 19, 2013 at 01:01:28PM -0700, Kevin Hilman wrote:
> Felipe Balbi <balbi@ti.com> writes:
>=20
> [...]
>=20
> > If you have 200 pm_runtime_get() followed by 200 pm_runtime_put() (put
> > is called only after 200 gets, no put-get ping-pong), your
> > ->runtime_resume() gets called once, your ->runtime_suspend() gets
> > called once but your ->runtime_idle() will get called 200 times.
>=20
> No. The driver's ->runtime_idle() will only be called when the usecount
> goes to zero.

Indeed, just re-read the code.

--=20
balbi

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwhrnAAoJEIaOsuA1yqREuoYP/33q8il0DFT8b6TJc7XigVPE
Qvq374LOyaPUmJpOUqwRF/bVVRTeLU+jgaizHjs6lMO4m5cTC0iluuwPz71OhRSU
rpwjElH7iwcf8Qy3kPqazAJnprwDDWH2ZW7QLsdKjBg0tYntFRTBo96ztxrGRygu
C+rcOhHcszuyRQHhznLBg9J2z6XMha18M7Hn93ZPiFlS7njn8q8kBnDobd/5eMZh
c/1k9NW2TL6EGGQ5wFZOZ8vce5IjyrQscQDZJre675I5w7C+SyPCE/hT2bzgsXmr
UIs/y+VwDbSGSBTzVH/Sn4TnOc/ONSSwybJVqUwS8sB47LUvGLDZcDlwuBwLIGoU
peQ2v3Hd9u65+J74PH4nCQLXlMYej5L7u8S786qQiQ9MSsB/L3CEAVLBw8Infsiz
We24gC1nf0Yu2B68+t/Bp/dQxsXJ3D9Bp7rjWFQXnXz9f0xeKOMgnfauf4hXZuxc
v3c7LwPxMUxJOTmromVa9OjDXr8yr7HcZeFUwzlh1EXIj2b24g5WOvl5PitRoilg
5hk2UFOwkETN6safscBJ21EIbijYMoLvMtbLUtImPP7QkYIF+gLXABIvEWZbMgJi
5vhZvuF6WmhUWK9wK8dyYNIZRSrZHNUwH2s9EfUeRst/Qfkl5AJuamuZ8lCf5nW2
RO/nCdM1QGbip8tlrkHx
=4Siu
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
