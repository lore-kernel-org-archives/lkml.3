Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaLHRe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:34:58 -0500
Received: from sauhun.de ([89.238.76.85]:42737 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbaLHRe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:34:56 -0500
Date: Mon, 8 Dec 2014 18:34:32 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Addy Ke <addy.ke@rock-chips.com>, Max Schwarz <max.schwarz@online.de>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tao Huang <huangtao@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?utf-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jianqun Xu <xjq@rock-chips.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        caesar <caesar.wang@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Han Jiang <hj@rock-chips.com>, Shunqian Zheng <zhengsq@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C spec
Message-ID: <20141208173432.GA5732@katana>
References: <1415261514-4051-1-git-send-email-addy.ke@rock-chips.com>
 <1418007589-3688-1-git-send-email-addy.ke@rock-chips.com>
 <20141208085202.GA13486@pengutronix.de>
 <CAD=FV=V=PDPiDhDmd+j8ePsF43EvuFP-LxKgMKo7ZRBzSMyOJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <CAD=FV=V=PDPiDhDmd+j8ePsF43EvuFP-LxKgMKo7ZRBzSMyOJA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > There are different capitalisation of i2c in the patch and the commit l=
og. I
> > don't know what Wolfram prefers here, but using the same spelling
> > everywhere would be nice.
>=20
> Can you please point out?  IIRC you should always capitalize I2C in
> prose (descriptions, comments, documentation, etc).  However when used
> in places which specific capitalization standards it should be
> lowercase.  That means file names, directory names, device tree
> property names, etc should be lower case.

This is what I prefer, too. However, I am not too strict about it.
I mean, both are readable.

> >> +     /* Read rise and fall ns; if not there use the default max from =
spec */
> >> +     if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-rising-time=
-ns",
> >> +                              &i2c->rise_ns)) {
> >> +             if (i2c->scl_frequency <=3D 100000)
> >> +                     i2c->rise_ns =3D 1000;
> >> +             else
> >> +                     i2c->rise_ns =3D 300;
> >> +     }
> >> +     if (of_property_read_u32(pdev->dev.of_node, "i2c-scl-falling-tim=
e-ns",
> >> +                              &i2c->fall_ns))
> >> +             i2c->fall_ns =3D 300;
> >> +
> > I don't know if other drivers do the same (I assume they should). If so,
> > moving this logic into the core would be nice. I guess this can still be
> > done later.

Let's leave that for later. If we do it, we should start with bus speed
setting first, probably.


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUheEoAAoJEBQN5MwUoCm2d50P+gLCIO+q+hHdrmpuN+gSsgrW
ZOA2Pzu/OIxSROcIkaflb189RUpZ0NNBKCF5R4WxeHPYJy38B2S9kMYKSw9HF4Vl
66cg/x/RQX7Tdd4RH15ItXILN/OvegotwDY/Qmh3zE1+FpnjBGnQmHWzVNcBfPFF
84/50dwmFUznSDr/8ZkrCgJXe2tmdOWdSleY0lqoq+9pYcCmhtcyHoiUm9RZ19HV
DOu2fODtH8flhVM7EO6K0QV2+QQmeMInSvw3TMTwFKtdVivXBcGlcFvA9PqnvicD
+srv6WzV22lU6lMEvdOLlzCOC/kzR1uq3Fo0TuMvk6nDwg7x3RevE4+Nauu+iNp8
c+mc9JHyYmeSUctrLHGQek7AD8i6dsYosXlf0Iq8lyNTVl00kwA76CcbWU/+hVqY
c7fu8M96E/jKloduJX8W1vxTdJZGOfU1j3adC19I/TU4UGTvEPleQcEHOe5hxWgK
ThN8YXAyE/6dKgYC5Kj2uXpHZK+KXf/xfi1S4ZumhPGtHxnoLDPbBKRGbZ2u0B6T
Ok/I918QoGy4NcxXLQI+4zGxxwSJ1EEIK9+dg4VFTmtao2sjoh9zHEwKprujrBXf
tZdFkFYhI6LBJAszLlNttOxBZez53dmj7ykRsqEY/Wia9xJDK6ezRXuKOvsWl0Mp
2s8PGFp05PsHCRhAZiZ/
=F7XD
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
