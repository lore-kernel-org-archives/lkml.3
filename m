Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaE0IfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41778 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751617AbaE0IfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:35:05 -0400
Date: Tue, 27 May 2014 10:30:21 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 17/22] mfd: sun6i-prcm: Add support for Allwinner A23 PRCM
Message-ID: <20140527083021.GE4730@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-18-git-send-email-wens@csie.org>
 <20140525191434.GX10768@lukather>
 <CAGb2v66cV_nRpHhrtDUYzncO5wimx+vRBW6BFcU0Kz=bKkNs+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Content-Disposition: inline
In-Reply-To: <CAGb2v66cV_nRpHhrtDUYzncO5wimx+vRBW6BFcU0Kz=bKkNs+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 12:36:38PM +0800, Chen-Yu Tsai wrote:
> On Mon, May 26, 2014 at 3:14 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, May 23, 2014 at 03:51:20PM +0800, Chen-Yu Tsai wrote:
> >> The Allwinner A23 SoC has a PRCM unit like the previous A31 SoC.
> >> The differences are the AR100 clock can no longer be modified,
> >> and the APB0 clock has different divisors.
> >>
> >> This patch adds a compatible with a modified subdevice list for
> >> the A23.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  .../devicetree/bindings/mfd/sun6i-prcm.txt         |  2 +-
> >>  drivers/mfd/sun6i-prcm.c                           | 30 +++++++++++++=
+++++++++
> >>  2 files changed, 31 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b/Do=
cumentation/devicetree/bindings/mfd/sun6i-prcm.txt
> >> index 1f5a31f..03c5a55 100644
> >> --- a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> >> +++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> >> @@ -4,7 +4,7 @@ PRCM is an MFD device exposing several Power Managemen=
t related devices
> >>  (like clks and reset controllers).
> >>
> >>  Required properties:
> >> - - compatible: "allwinner,sun6i-a31-prcm"
> >> + - compatible: "allwinner,sun6i-a31-prcm" or "allwinner,sun8i-a23-prc=
m"
> >>   - reg: The PRCM registers range
> >>
> >>  The prcm node may contain several subdevices definitions:
> >> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
> >> index 718fc4d..c96bb6c 100644
> >> --- a/drivers/mfd/sun6i-prcm.c
> >> +++ b/drivers/mfd/sun6i-prcm.c
> >> @@ -76,16 +76,46 @@ static const struct mfd_cell sun6i_a31_prcm_subdev=
s[] =3D {
> >>       },
> >>  };
> >>
> >> +static const struct mfd_cell sun8i_a23_prcm_subdevs[] =3D {
> >> +     {
> >> +             .name =3D "sun6i-a31-apb0-clk",
> >> +             .of_compatible =3D "allwinner,sun8i-a23-apb0-clk",
> >> +             .num_resources =3D ARRAY_SIZE(sun6i_a31_apb0_clk_res),
> >> +             .resources =3D sun6i_a31_apb0_clk_res,
> >> +     },
> >> +     {
> >> +             .name =3D "sun6i-a31-apb0-gates-clk",
> >> +             .of_compatible =3D "allwinner,sun6i-a31-apb0-gates-clk",
> >> +             .num_resources =3D ARRAY_SIZE(sun6i_a31_apb0_gates_clk_r=
es),
> >> +             .resources =3D sun6i_a31_apb0_gates_clk_res,
> >> +     },
> >
> > Did I just have a brainfart, or didn't you just introduced an
> > sun8i-a23-apb0-gates-clk driver?
>=20
> My bad, I missed this one. The one in the DT is correct.
> It actually works, so I'm a bit confused here.
> Which one does the driver core actually use?

Actually, it will use both, and will match the of_compatible string
try to match it against the mfd-sub-nodes compatibles. If nothing
matches, it won't fill the dev.of_node field.

>=20
> > And there's no ar100 and ahb0 clocks ?
>=20
> The ahb0 is a fixed-factor (1:1) clock. There are no controls for it.
> The ar100 clock on the A23 has no controls either, so fixed-factor
> clock again.

Ack.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThE0dAAoJEBx+YmzsjxAg38EP/035jkjbn8xrfVMZTORgZYE1
rU9ATQ7Z6mMqajcZ7Ut+RnKJtBcPnQvG6AtHnj4B/WUn1ho6blt3/5MJ8mEJCslR
hZv/4ZpQUeRwUh186RIl3A1/AGvsSC0q9mAoXcLMm4gwTk5GcUEc8ojhYwmYFIu1
Ws67Uf/5eKC58d53XZUPP0h1PyI6EvBzjFPL1XnbVRlD9gEN+gmt4MAWF3ZJMrIv
OyT+j0YoftiE7/DI9mzTDEeRbenqGFKVeyYbB0rsuuQA7GtENQa5Jj6klJxYbtl+
lMt2/3QohxB8zue5F3gD+1d9hW9p/Mqqhsc5yAqISw8IrnE1gY2q6tUhqElwe0eR
7ef7h1avfXeYfiNR3FCgO0jhIWhz9B9kK8zwOgj34Pe0WB4bdBPLy2MOsn5WAz7F
HLd1goDCmefpFWJyAaaDl8pvv+nogn//ZdsDGXb0CQdhrsWlRxqDs1HcTuJn1Gp5
qdtnbPsVdaJu7J3aXC8vElimGg+KBF7ckCl0JDe0PW4Psp6ppN+riXWuLDxi/QcP
E20egYnNxecDn/UpgoU15X5hWSpzgaRjiqYrwKTOMVJrnVEd0+tGYqEUFVKXDNsD
YXeFB2CQV+LhTcsyZUqXiYIZnFve3aj0XanFVEQnNV+fCqf5XTpZyBykepx2A3/n
r20ywd4ETfW546zevAOP
=2LgE
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
