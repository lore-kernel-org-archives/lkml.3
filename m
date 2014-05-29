Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaE2TfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:35:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53047 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011AbaE2TfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:35:05 -0400
Date: Thu, 29 May 2014 21:31:35 +0200
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
Message-ID: <20140529193135.GY4730@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-18-git-send-email-wens@csie.org>
 <20140525191434.GX10768@lukather>
 <CAGb2v66cV_nRpHhrtDUYzncO5wimx+vRBW6BFcU0Kz=bKkNs+g@mail.gmail.com>
 <20140527083021.GE4730@lukather>
 <CAGb2v65v7rqBwFbn1JtQv44nQxepAq-ciwsBdHaELbzWXQNU9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hkxLWrKAgbGf75mf"
Content-Disposition: inline
In-Reply-To: <CAGb2v65v7rqBwFbn1JtQv44nQxepAq-ciwsBdHaELbzWXQNU9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hkxLWrKAgbGf75mf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2014 at 12:23:58PM +0800, Chen-Yu Tsai wrote:
> On Tue, May 27, 2014 at 4:30 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Mon, May 26, 2014 at 12:36:38PM +0800, Chen-Yu Tsai wrote:
> >> On Mon, May 26, 2014 at 3:14 AM, Maxime Ripard
> >> <maxime.ripard@free-electrons.com> wrote:
> >> > On Fri, May 23, 2014 at 03:51:20PM +0800, Chen-Yu Tsai wrote:
> >> >> The Allwinner A23 SoC has a PRCM unit like the previous A31 SoC.
> >> >> The differences are the AR100 clock can no longer be modified,
> >> >> and the APB0 clock has different divisors.
> >> >>
> >> >> This patch adds a compatible with a modified subdevice list for
> >> >> the A23.
> >> >>
> >> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> >> ---
> >> >>  .../devicetree/bindings/mfd/sun6i-prcm.txt         |  2 +-
> >> >>  drivers/mfd/sun6i-prcm.c                           | 30 ++++++++++=
++++++++++++
> >> >>  2 files changed, 31 insertions(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b=
/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> >> >> index 1f5a31f..03c5a55 100644
> >> >> --- a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> >> >> +++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
> >> >> @@ -4,7 +4,7 @@ PRCM is an MFD device exposing several Power Manage=
ment related devices
> >> >>  (like clks and reset controllers).
> >> >>
> >> >>  Required properties:
> >> >> - - compatible: "allwinner,sun6i-a31-prcm"
> >> >> + - compatible: "allwinner,sun6i-a31-prcm" or "allwinner,sun8i-a23-=
prcm"
> >> >>   - reg: The PRCM registers range
> >> >>
> >> >>  The prcm node may contain several subdevices definitions:
> >> >> diff --git a/drivers/mfd/sun6i-prcm.c b/drivers/mfd/sun6i-prcm.c
> >> >> index 718fc4d..c96bb6c 100644
> >> >> --- a/drivers/mfd/sun6i-prcm.c
> >> >> +++ b/drivers/mfd/sun6i-prcm.c
> >> >> @@ -76,16 +76,46 @@ static const struct mfd_cell sun6i_a31_prcm_sub=
devs[] =3D {
> >> >>       },
> >> >>  };
> >> >>
> >> >> +static const struct mfd_cell sun8i_a23_prcm_subdevs[] =3D {
> >> >> +     {
> >> >> +             .name =3D "sun6i-a31-apb0-clk",
> >> >> +             .of_compatible =3D "allwinner,sun8i-a23-apb0-clk",
> >> >> +             .num_resources =3D ARRAY_SIZE(sun6i_a31_apb0_clk_res),
> >> >> +             .resources =3D sun6i_a31_apb0_clk_res,
> >> >> +     },
> >> >> +     {
> >> >> +             .name =3D "sun6i-a31-apb0-gates-clk",
> >> >> +             .of_compatible =3D "allwinner,sun6i-a31-apb0-gates-cl=
k",
> >> >> +             .num_resources =3D ARRAY_SIZE(sun6i_a31_apb0_gates_cl=
k_res),
> >> >> +             .resources =3D sun6i_a31_apb0_gates_clk_res,
> >> >> +     },
> >> >
> >> > Did I just have a brainfart, or didn't you just introduced an
> >> > sun8i-a23-apb0-gates-clk driver?
> >>
> >> My bad, I missed this one. The one in the DT is correct.
> >> It actually works, so I'm a bit confused here.
> >> Which one does the driver core actually use?
> >
> > Actually, it will use both, and will match the of_compatible string
> > try to match it against the mfd-sub-nodes compatibles. If nothing
> > matches, it won't fill the dev.of_node field.
>=20
> So actually it was supposed to use "allwinner,sun6i-a31-apb0-gates-clk",
> as that clk driver takes clock-indices, so no need to define gate masks
> and tie them to some new compatible.
>=20
> There was no sun8i-a23-apb0-gates-clk driver.
>=20
> I must not be getting enough sleep.

I'd still prefer it to have a different compatible though, at least to
be consistent.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hkxLWrKAgbGf75mf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTh4sXAAoJEBx+YmzsjxAg6CwQAIxhoO81tWNvpF3+U3mm1lBl
qsDxCCF8xwuXMZHwMvU8nVNJOmIqMhVlpxMBE2SBfM8W9/EUuaY4ttNxpt8ufj28
FZifJT8YW1pzNqB8/bqIA+1U3aue1UCQrgxjhafNKfzl4oL8X81HJnmCKacSIimW
fs2gg31ZCTeCxzVdes5lv9WQX5UfmCQCZcbURaV9oDeDDlRhtgZCRBt38X6yuqBO
kaXL7T/cya38/lRVkYCj4YlxBIqbjk8CCOGOyr/47S0imQvwbFjoD3ZD89lBxQW1
goA12F4xfXap9Q0BWFXrDTWIQOgff6V+fHuzM54I7tJtWxkb9nb5ADrz/Gv0it71
CcvpHEmNesZpzYBOZhAA47tFya7Rp5JpxiiVignHR+RchtYM2CaMWv6vVrOQPrpp
Xc1jUZ+mGiAf/Si50oWQf7AGFSPum9+aoIHsKUJMjyPANuVuhp//GN2MMRzRlsjt
n9c0BDOHnWm2MOKogdS813dPx4iIQS6P6e4TASTKL9Fe49JsWQRMUgsbKKATDmVV
uM1orwP0UrUCIFNxbXcW+ltnbX7FUNiO469GMfzUbGjjQtF/jeS2XVDO0EIuM84v
71m5NfLrok3HyTs5vlGyDDpxlXJ+3b3n2lCGJcxUUA4oyeOBar8oLXN9wJHEGHBU
ZfPshAvWpra3VKi0t6a8
=O5yc
-----END PGP SIGNATURE-----

--hkxLWrKAgbGf75mf--
