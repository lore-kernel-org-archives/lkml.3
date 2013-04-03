Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560Ab3DCIR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:17:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53106 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760423Ab3DCIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:17:25 -0400
Date: Wed, 3 Apr 2013 11:17:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <sarah.a.sharp@linux.intel.com>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <kishon@ti.com>, <dianders@chromium.org>,
        <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 02/11] USB: dwc3: Adjust runtime pm to allow
 autosuspend
Message-ID: <20130403081704.GF25837@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-3-git-send-email-gautam.vivek@samsung.com>
 <20130402082952.GG30286@arwen.pp.htv.fi>
 <CAFp+6iFv43Xbck1cy8AcvGzBrxOECHLjowfV7askCCYgFFgNrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64j1qyTOoGvYcHb1"
Content-Disposition: inline
In-Reply-To: <CAFp+6iFv43Xbck1cy8AcvGzBrxOECHLjowfV7askCCYgFFgNrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--64j1qyTOoGvYcHb1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 11:35:43AM +0530, Vivek Gautam wrote:
> >> The current code in the dwc3 probe effectively disables runtime pm
> >> from ever working because it calls a get() that was never put() until
> >> device removal.  Change the runtime pm code to match the standard
> >> formula and allow runtime pm to function.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> CC: Doug Anderson <dianders@chromium.org>
> >> ---
> >>  drivers/usb/dwc3/core.c |    8 +++++++-
> >>  1 files changed, 7 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >> index e2325ad..3a6993c 100644
> >> --- a/drivers/usb/dwc3/core.c
> >> +++ b/drivers/usb/dwc3/core.c
> >> @@ -491,6 +491,11 @@ static int dwc3_probe(struct platform_device *pde=
v)
> >>
> >>       dwc->needs_fifo_resize =3D of_property_read_bool(node, "tx-fifo-=
resize");
> >>
> >> +     /* Setting device state as 'suspended' initially,
> >
> > wrong comment style.
> Yea :-(  will fix this.
>=20
> >
> >> +      * to make sure we know device state prior to
> >> +      * pm_runtime_enable
> >> +      */
> >> +     pm_runtime_set_suspended(dev);
> >
> > didn't Alan mention this should be done at the Bus level ? In that case,
> > shouldn't you have call pm_runtime_set_active/suspended() based on
> > DT's status=3Dokay or status=3Ddisabled ? Or something similar ?
>=20
> True, we should be doing this at bus level. But he did also mention to
> let pm core
> know of the state of the device before enabling the runtime pm. Right ?
> Moreover immediately after pm_runtime_enable(), we do pm_runtime_get_sync=
()
> so that device comes to active state.
> I am possibly missing things out here, not able to grab this whole
> picture completely :-(
>=20
> Wouldn't DT's status=3Ddisabled actually be disabling the device as a who=
le ?
> So, how much will runtime power management on the device be affecting ?

indeed, maybe we can keep it like this, but it would be nice to have OF
core handle this for us based on whatever data.

--=20
balbi

--64j1qyTOoGvYcHb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW+WAAAoJEIaOsuA1yqREAbEQAJN7c56KGGLZ1Xx50kl5jg4v
/YpRMCXHhOCNBYV5anbQcVWySbgRDovARenZf3P1nEhlSKeqTAX7wTO+boiTc7Dm
759ChU7RHu9alumXwYOD/OHSvaTAYXn6IcWvktqv+5CXCzt3SPBFSdIpUxzxbMHb
Y+WAliuVzSPT4ulNtiPTKa3i3MH0ELOAAPdkVTNGwsG46QVCg+WjscuJC96JyYhh
zESvoD9hugEUszgujAKS4Z3rliIujTFUs5YY6VwbMLLjMXsr75TwVfogpUCAWj3h
K8D47vxQ8pawC7PCJtzU2MjFwGFqwm4UfgvIKom3fS1dh5E1IRNY+KFD7gZ0G68C
h2GeVOKh+D7RKkgCP8p8kzdfmLZ7r9v00RLycncpxkbfOOSnyahCDFWpanEMppGg
DgI18OZruGWLwFBG69Vv55cgPuF9XbVsP4V3knAJnOSZjydZBhTiTp3uVGeiM0d+
9xL09SNYhV432O+TFjRLRpsG7saS88Aj8zXXt2oSZh4oSkjmXQ/BuD2rgZ7OW762
+9sOLdNT0GlqyzPLji2sSvAIploofOS8uu//iwnrBs9crpF6B2bGYrh03uGS+Q1a
/SA9V+9woIgt2Jl+far/NobuV0Zbgtyb0d9yTkFSfvMQcfSgq0eJVokOZWPDfXqG
zlxwcDkbMCo0g2aJbn2h
=PoH1
-----END PGP SIGNATURE-----

--64j1qyTOoGvYcHb1--
