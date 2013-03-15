Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3COHnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:43:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56066 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3COHnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:43:11 -0400
Date: Fri, 15 Mar 2013 09:42:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <dianders@chromium.org>,
        kishon <kishon@ti.com>
Subject: Re: [PATCH 2/2] usb: dwc3: exynos: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20130315074253.GE5074@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
 <1363257898-17504-3-git-send-email-gautam.vivek@samsung.com>
 <20130314105320.GH32369@arwen.pp.htv.fi>
 <CAFp+6iEHVi4W-be4t1k3K=Yz8OP150rtBmNKXR0xnFiA3Oa3qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6e7ZaeXHKrTJCxdu"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEHVi4W-be4t1k3K=Yz8OP150rtBmNKXR0xnFiA3Oa3qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6e7ZaeXHKrTJCxdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 15, 2013 at 11:36:00AM +0530, Vivek Gautam wrote:
> >> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unpre=
pare
> >> calls as required by common clock framework.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> CC: Felipe Balbi <balbi@ti.com>
> >> CC: Kukjin Kim <kgene.kim@samsung.com>
> >> ---
> >>  drivers/usb/dwc3/dwc3-exynos.c |    6 +++---
> >>  1 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-ex=
ynos.c
> >> index 66ca9ac..b03f609 100644
> >> --- a/drivers/usb/dwc3/dwc3-exynos.c
> >> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> >> @@ -129,7 +129,7 @@ static int dwc3_exynos_probe(struct platform_devic=
e *pdev)
> >>       exynos->dev     =3D dev;
> >>       exynos->clk     =3D clk;
> >>
> >> -     clk_enable(exynos->clk);
> >> +     clk_prepare_enable(exynos->clk);
> >
> > eventually we need to pass this clock handling to dwc3/core.c. Just make
> > sure it's optional since not all platforms need it.
> >
> True, as of now i could see only exynos platform getting a device
> clock for dwc3-glue.
> So, if not all platforms need to do this, why should we plan to move
> this to dwc3/core.c ?

what if dwc3.ko's probe fail ? Clock will be left enabled ;-)

> > I guess the best way would be to handle clocks via
> > ->runtime_suspend()/->runtime_resume() ??
>=20
> Right, but there was a doubt actually if you can please clear that.
> In device probe, after enabling runtime_pm we would need to
> 'pm_runtime_get_sync' the device.
> Thereby, in runtime_resume the clocks will be enabled.
> Now as soon as the device probe finishes, the device will go in
> suspend state, calling runtime_suspend
> and the clocks would be disabled.
> Now would it be possible for the controller to detect any
> connect/disconnect.

it depends on how you have configured your core in coreConsultant and
how you're implementing the actual IP. If you have retention flip-flops
then gating clocks (but not cutting Vcc) will not loose context and, if
PHYs are still enabled, you will see new connect events.

But that part of PM optimization has to be done as a last step, as it
tends to break things apart.

--=20
balbi

--6e7ZaeXHKrTJCxdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQtD9AAoJEIaOsuA1yqREFOkQAKCmOlnp7INARIevLDAXxWyb
OPJz/CVvS8gF9WtBhokKWbi/3/bkkLzNiEYm3oYQaI2P6XQ3AGz4YyG1RbbtH04C
+fIjXey6xrmI2gvYGLwp+vD8X2FoBCwdVjkG52v9A0wPt39W2X759e27sZdodP73
RaGeCHFivEI6M6hoNzqg8JSxdMmwbncIlplRp6no6NaIdlrhIS4PkH1jxkMPSJxl
kP0tvVue4W/N4iUrHK/LjIQb21r/Bzeo4LkwT02lRttMLKP6T0WAI7orXE/klLea
cLT3ST+seQfEGNfZGTJS+E7Tf/hseyibmO8yKJY/slDfiRRcjfpnVegWCpKfH5M7
hMYRw6KaYguTKFELbCIChMfmZ2mxiWeeCdkve4lkTH7QLn/VMyKDdCV40Kah7Ziz
NkEZgEyCo8my9fdjaviB48RsfzJsXv+P7Rn4EAHIg4i0uWh61sRMx0Kui5bMYjwC
oAstZK7mxS/i7YFKlPeA0sh/aiKByLaH8mgohRvIx06SxJP8B/69Kzh5M9Tav19I
z8v/wTw6AcEJvkAd9tj2qlUsXgDG3/BAu8R4E7Es/w6Sh+fuN674wXarX8m4MBsi
uj69fRe+RKzSmSNDiJmggVdBwt9CblZFGCUKetAtN+SI8Ku5jCSBZR9vyytfgPmX
sqcNRx889bRiBQupY3Rx
=VjjP
-----END PGP SIGNATURE-----

--6e7ZaeXHKrTJCxdu--
