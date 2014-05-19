Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbaESOFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:05:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52328 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754233AbaESOFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:05:04 -0400
Date: Mon, 19 May 2014 16:03:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 0/3] mfd: AXP22x: add support for APX221 PMIC
Message-ID: <20140519140319.GI29466@lukather>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, May 15, 2014 at 07:51:42PM +0200, Boris BREZILLON wrote:
> Hello,
>=20
> This patch series adds basic support for the X-Powers' AXP221 PMIC.
> It's mainly based on Carlo's series [1], which is almost merged (at least
> the mfd and regulator drivers are merged).
>=20
> At the moment I only added support for the AXP221 regulators but other
> subdevices will be added later.
>=20
> But, before going any further in my developement I'd like to get feedback
> on some points:
>=20
> 1) I'm pretty sure we can share some code between the axp20x and axp22x
>    drivers, but I'm not sure how it should be done:
>  a) defining an axp2xx-core.c driver and make the axp20x and axp22x driver
>     use this core implementation.
>  b) just share some macros (like the AXP_DESC one) and the keep drivers
>     separated
>  c) keep only one generic driver that support all PMICs revisions (axp2xx-
>     drivers).
>=20
> 2) The ipsout regulator is currently represented as a fixed regulator
>    providing a 5v output, and this is not exactly the case.
>    AFAIU (here's is the datasheet traduction if you want to check [2]), t=
he
>    ipsout output is a multiplexer that choose among vbus (5V), acin (12V
>    which is then converted to 5V) and the battery power supply (3,5 -> 4,=
2 V).
>    This means the output voltage of ipsout vary between 3,5V and 5V.
>    How can we express this kind of muxer in the regulator framework (is t=
here
>    already something available ?) ?

One thing I'd like to add to this, is that even though the IPSOUT
voltage itself is between the 3.5 / 5V boundaries, there is an
external regulator that boost the voltage to 5V, before being actually
used by any other device on the boards, including the other regulators
that the PMIC can output.

It basically looks like something like this:

+---------------------------------+
| ACIN (12V) -------+             | (3.5 - 5v)
| USB VBUS (5V) ----+----- IPSOUT +-----------------+--------------+
| BAT (3.5 - 4.2V)--+             |                 |    +---------+-------=
---+
|                                 |                 |    |   External Boost=
   |
|                                 |                 |    |      Regulator  =
   |
|    PMIC                         |                 |    +---------+-------=
---+
|                                 |                 |              +-------=
-------+--- VCC 5V
|                   +-------------+    (3.5V - 5V)  |                     (=
5V)    +--- USB
|                   |        VIN -+-----------------+                      =
       +--- HDMI
|                   | Random      |                 =20
|                   | Regulator   |
|                   |             |      (Random V)
|                   |       VOUT -+------------------------
|                   +-------------+
+---------------------------------+

For the some moment, the IPSOUT regulator is decribed as a fixed
regulator, but that seems a bit inaccurate.

Do you have a suggestion?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTeg8nAAoJEBx+YmzsjxAgWpMQAJpMs9nWvytS01DCDO9QTHpl
QIuYybkMfBIGxbJn8rMWJmE16NoSx4Tg2nCgqieJtBvnwr8sxgIOfvKFy+gR0FGO
RmK5U/KT8pnoXf9DhfS0eHo1aHV4eJivyJlujeEeMEKIJgETG92HthKADNaozzN/
COg3MpwVHPe2zEfF3MoCqBivGZt1NakDYeALgQx2ZaiKnmqcISll2T9DCZv1H+KY
4TOjPurlldvKoTycec1jAZvzqHpcl2BnrqM0ZwLRR7sVeqnyAWfZcRq3ftPi1qzq
bbHehu4hQHjhhLIG8fVOTy+/RF8rKYVTIPowOGHJ/E2o+IIyZPa7glHO1m3rud/w
+mLf7XEdHO3LcGuvZf0stqy3bs8iI/EXv5heofcBXxTch9BxzYx3H5+xY39sUZlW
Y2JwpjIluGwVhSjXxn+ogHifeMTE6OcPfBW7wmXCxLsMkWHD3vau4vNYyBIJyUXU
bSTMKjiOon9tr2GrVEGynBTotrdc/WKnqrC7msUzYsFInO1EPmFL1bSKfEBbMpOK
48xm9Gn9GeZ3HU6gG58BSABb8z+sQ/0o1Dg9be7vwa/UhhyxyMNg4DLeyYEOWN70
0P5bsOq0N5JBHcLpgfyTwBPh1MDJfga1B50pwOwq7lzhjlpHy3+tq4vHC+tVmMew
3MJ9CNL8AU5nu2IPNtgq
=C4/c
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
