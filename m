Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbaGIIkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:40:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44352 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301AbaGIIkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:40:05 -0400
Date: Wed, 9 Jul 2014 10:35:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: a case for a common efuse API?
Message-ID: <20140709083509.GQ13423@lukather>
References: <53BC4DD7.20906@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3mUD2hqWbnBptYHy"
Content-Disposition: inline
In-Reply-To: <53BC4DD7.20906@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3mUD2hqWbnBptYHy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Tue, Jul 08, 2014 at 01:00:23PM -0700, Stephen Boyd wrote:
> Hi,
>=20
> On MSM chips we have some efuses (called qfprom) where we store things
> like calibration data, speed bins, etc. We need to read out data from
> the efuses in various drivers like the cpufreq, thermal, etc. This
> essentially boils down to a bunch of readls on the efuse from a handful
> of different drivers. In devicetree this looks a little odd because
> these drivers end up having an extra reg property (or two) that points
> to a register in the efuse and some length, i.e you see this:
>=20
> 	thermal-sensor@34000 {
> 		compatible =3D "sensor";
> 		reg =3D <0x34000 0x1000>, <0x10018 0xc>;
> 		reg-names =3D "sensor", "efuse_calib";
> 	}
>=20
>=20
> I imagine in DT we want something more like this:
>=20
> 	efuse: efuse@10000 {
> 		compatible =3D "efuse";
> 		reg =3D <0x10000 0x1000>;
> 	}
>=20
> 	thermal-sensor@34000 {
> 		compatible =3D "sensor";
> 		reg =3D <0x34000 0x1000>;
> 		efuse =3D <&efuse 0x18>;
> 	}

We have pretty much the same things in the Allwinner SoCs. We have an
efuse directly mapped into memory, with a few informations like a MAC
address, the SoC ID, the serial number, some RSA keys for the device,
etc.

The thing is, some boards expose these informations in an external
EEPROM as well.

I started working and went quite far to create an "eeprom" framework
to handle these cases, with a dt representation similar to what you
were exposing.

https://github.com/mripard/linux/tree/eeprom-framework-at24

It was working quite well, I was about to send it, but was told that I
should all be moved to MTD, and given up on it.

Anyway, +1 for this :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3mUD2hqWbnBptYHy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTvP69AAoJEBx+YmzsjxAga/AP/0snbZUhuilXjUC7EZM9osse
MmLGdXhw7CiZwmJ7jsFRFmySlvyGqRZwKgUg/dZGCZBdMD9ifHdon36cnjcyNb8M
6OHkavb4yDp60pIbS2x2R5AhEHz9sH1NM86Rjr4Ab3Lnz497SmYTvKXsViIxJM7w
AUyltRLK8ATgznJUedA7HUZe/BN8Zb9VLcA2YuJbCG0UrUdqF+MHZuIhnGrn+cco
b003EhKhR/ndI0fr9bnamM5KsmgxZ4RCNkjGy53ILs4nX05n4W7+AIjrhcgMRYod
XR6bQaSlVunccWF7DLmEU2oI64dgVlHwBpH3bdmXn79D7YYiFSFm3E3BheDA219u
27jCtwaYIViFtYX+UBWxjbu+Tb7gelJyMEnNwe9vQiQakA0kPf0lS/vLgM7g4Wdc
aF2L9vEkkLwGtKq9PDsdQharvpCfP9FQiLJ3FFCG3c+L/MPtBt3+5dupdnNUsR21
0QhjNZLhylC65P1VOOOr2bVe+H7rGBDUFP4iZg2LH6W+XwQAULWqWntChQGR+6os
aNzqMvqTrN87QyqV0IwTQZhmUrm2p9llklzh/yEF3RQX4cYYso7JfGfOeTvfvVyv
AiIEsI4wzvNyDyoFqww1IyGzMdozzU2oh9MPrzexUOO+d1mXCfIJJ61v+sCIUuoE
UDvu6d+1rkSpEEP62lVB
=lmkk
-----END PGP SIGNATURE-----

--3mUD2hqWbnBptYHy--
