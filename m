Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbaJ3OKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:10:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48111 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758428AbaJ3OKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:10:03 -0400
Date: Thu, 30 Oct 2014 09:07:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 8/8] usb: dwc2: move usb_disabled() call to host driver
 only
Message-ID: <20141030140705.GG6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-9-git-send-email-dinguyen@opensource.altera.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E6ACC@US01WEMBX2.internal.synopsys.com>
 <5450ED1C.7030208@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Content-Disposition: inline
In-Reply-To: <5450ED1C.7030208@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2014 at 08:35:24AM -0500, Dinh Nguyen wrote:
>=20
>=20
> On 10/28/14, 8:26 PM, Paul Zimmerman wrote:
> >> From: dinguyen@opensource.altera.com [mailto:dinguyen@opensource.alter=
a.com]
> >> Sent: Tuesday, October 28, 2014 4:26 PM
> >>
> >> Now that platform.c will get built for both Host and Gadget, if we lea=
ve the
> >> usb_disabled() call in platform.c, it results in the following build e=
rror
> >> when (!USB && USB_GADGET) condition is met.
> >>
> >> ERROR: "usb_disabled" [drivers/usb/dwc2/dwc2_platform.ko] undefined!
> >>
> >> Since usb_disabled() is mostly used to disable USB host functionality,=
 move
> >> the call the host portion for the DWC2 driver.
> >>
> >> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> >> ---
> >>  drivers/usb/dwc2/hcd.c      | 3 +++
> >>  drivers/usb/dwc2/platform.c | 3 ---
> >>  2 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> >> index fa49c72..b741997 100644
> >> --- a/drivers/usb/dwc2/hcd.c
> >> +++ b/drivers/usb/dwc2/hcd.c
> >> @@ -2780,6 +2780,9 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int =
irq,
> >>  	int i, num_channels;
> >>  	int retval;
> >>
> >> +	if (usb_disabled())
> >> +		return -ENODEV;
> >> +
> >>  	dev_dbg(hsotg->dev, "DWC OTG HCD INIT\n");
> >>
> >>  	/* Detect config values from hardware */
> >> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> >> index 77c8417..123cf54 100644
> >> --- a/drivers/usb/dwc2/platform.c
> >> +++ b/drivers/usb/dwc2/platform.c
> >> @@ -157,9 +157,6 @@ static int dwc2_driver_probe(struct platform_devic=
e *dev)
> >>  	int retval;
> >>  	int irq;
> >>
> >> -	if (usb_disabled())
> >> -		return -ENODEV;
> >> -
> >>  	match =3D of_match_device(dwc2_of_match_table, &dev->dev);
> >>  	if (match && match->data) {
> >>  		params =3D match->data;
> >=20
> > I'm confused. You are saying the build is broken until patch 8/8 is
> > applied? As always, that is not acceptable. You need to fix the
> > breakage at the point where it was introduced, not leave it broken
> > until the last patch in the series.
> >=20
>=20
> The build gets broken when patch 7/8 of is applied. That is the patch
> that finally allows platform.c to get built for host and gadget. I can
> fold this patch into patch 7/8.

then you invert things, make $subject patch 7 (or even patch 1) and
patch 7 becomes patch 8.

--=20
balbi

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkYJAAoJEIaOsuA1yqREpqMP/RAwWmjP/l0GHFfSOVdMAYco
kIc4yJqcBaeeyqE2i1HbeEQQDGNX+PDkBjy7o5BSwwAIg5lBmcmfgdtLxUWGvSr8
a9GeVFZF8b9gsuRXBMOsSHPBoYlq1nWMZwDxvIfUz/J9Dh2XhmgMR3eIlQ9nWpui
GLjxGcIx/u4GSpQ7giI8UGbh6h0LbC5JVv6FkgrK+JZ/hEBFwFXmvR4Bted3/GOR
SaGne33Ly3sLMBumSV/3SbRsFEgotq3wgEFfQ+XLWY2eRb25+nfA4VzPbHDF2tax
QeEuP2WpT/9o3mRTsWCmWo+GErlhfJKIv5AeY9bknqZqPCD27sC6UkPrnETyJ9ds
nnRTNjo1aDqwqmPNgccdxCnu3U/3YSh1lyNkglOMWa6BisqGXOebBomIt34gpa0n
nIi45If2WtSRbjpg/SZR+UBLJKD0IL/M47mzCx25g7Ylh/PLHfJ5vFg0Ak4HE0oS
FpWbNHgoz3Mz7wFkXpJ1NyXJ0/D9YixOrjy0KLl9jDKt3bbzM/Parix7DMkfAxb/
mp2/H2LElBaw4gPpwp2+8gRSTxtiFcTvUmqI2HVObfVy1J29Dw6grUpmb/TJpxEE
7qBU+4ZDbkMnhuw8KwVfyFtVenrSiZwqH1DdIOxvgNrWXrvHYVRpmGoiHH6JTBcD
wCpcOCCWXW14Bv4it6FN
=ugKj
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
