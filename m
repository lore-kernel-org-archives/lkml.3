Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbbAMPeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:34:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40950 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbAMPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:34:09 -0500
Date: Tue, 13 Jan 2015 09:30:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Yunzhi Li <lyz@rock-chips.com>,
        "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "jwerner@chromium.org" <jwerner@chromium.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
Message-ID: <20150113153041.GB16533@saruman>
Reply-To: <balbi@ti.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
 <1418396972-32686-1-git-send-email-lyz@rock-chips.com>
 <A2CA0424C0A6F04399FB9E1CD98E03048450635E@US01WEMBX2.internal.synopsys.com>
 <54B14E0E.4070504@rock-chips.com>
 <A2CA0424C0A6F04399FB9E1CD98E030484506F3B@US01WEMBX2.internal.synopsys.com>
 <87ppajxbt3.fsf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <87ppajxbt3.fsf@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 10:35:52AM +0100, Robert Jarzmik wrote:
> Paul Zimmerman <Paul.Zimmerman@synopsys.com> writes:
> > The patch below fixes it. And it seems like the right thing to me,
> > since GPIOs should be optional for a generic phy, I would think. But
> > my device tree foo is very weak, so I'm not sure.
> >
> > CCing Robert, who touched the generic phy code last. Robert, what do
> > you think?
> I think your patch in [1] is correct, because
> "Documentation/devicetree/bindings/usb/usb-nop-xceiv.txt" states that
> reset-gpios is optional, and because Felipe told me gpios for phy_generic=
 are
> optional.
>=20
> Now the original code was written by Felipe, so better ask him first. The
> original code was :
> af9f51c55 phy-generic.c nop->gpio_reset =3D of_get_named_gpio_flags(node,=
 "reset-gpios",
> af9f51c55 phy-generic.c                                                 0=
, &flags);
> af9f51c55 phy-generic.c if (nop->gpio_reset =3D=3D -EPROBE_DEFER)
> af9f51c55 phy-generic.c         return -EPROBE_DEFER;

yeah, at the time that was written, there was no _optional() varianto of
get_gpio, if there is one now, we should use it, indeed.

I can rather easily test here on BBB to make sure there are no
regressions.

--=20
balbi

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtTogAAoJEIaOsuA1yqREiqwP/A6gpTU1iVGGCAeyKKgXUb7i
B729k828U6yaGsX78ln4OBrsSdvDpQI/2g1tmyxoVwCNZfA3Xbly62gje+0FNlTN
Lha9LevwbybkLNtiHe+EG7+GbsALhkDbgfqun8hK9U4ZfCbwxwx39QHMlnYoGN7Y
oAp0JCSD5ei2c2j3+77F2zKCZa78XTX1vwvR5u5avpcxc0q7d277OQ1Vn+MWeWAo
LhpY1GDBiJIXFM/l6zFWBFxmSkmO8VUVTV1o5XHQHl+H10wnGcUjjApVkg6XhKZs
+CiUFvLFuceVb2E46+F86sX0LAceH1UNsWEUUBo4QoJ0ZVo0KqpIgtZF4avZVpMN
lVcy81iLb5Sspia//YKbQcuASDboj7VwF7OcREddGvEL5xNkg0YYCzL8pVe7eXG+
+cVm8Nz+0982eLdJlNlPBnrc6lXkQ1faFWqpESlXklCaTyQTxy82QHXnCyfDy8ij
+o3klQ3+rZ/lUE++VsgpfKBWnLpK7nia/E1RrKwpqgZeTSqCIC2hznz7hAvqk880
d53aLOw3zojfELzRKs/gOjnMYDis0FFnZMfIsob9c6PvR0gphA4L0eHAG1pplNKH
SqwCe5/e25wuF11hpEXqi3E2H8PqmM918bFjhNlQ0nSgbqwFHaVGp5UY3em/FFxT
LKut7tAexCWk1wj1mMqd
=SmbR
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
