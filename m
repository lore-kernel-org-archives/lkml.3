Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab3FZMMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:12:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55250 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab3FZMMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:12:21 -0400
Date: Wed, 26 Jun 2013 15:12:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not
 available
Message-ID: <20130626121210.GA12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com>
 <20130626101647.GT12640@arwen.pp.htv.fi>
 <51CAD977.6040309@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vDpvzslK0qRw06MN"
Content-Disposition: inline
In-Reply-To: <51CAD977.6040309@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vDpvzslK0qRw06MN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 05:37:19PM +0530, George Cherian wrote:
> On 6/26/2013 3:46 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Jun 26, 2013 at 02:59:14PM +0530, George Cherian wrote:
> >>There can be configurations in which DWC3 is hoooked up only to USB2 PH=
Y.
> >>In such cases we should not return -EPROBE_DEFER, rather continue probe
> >>even if there is no USB3 PHY.
> >>
> >>Signed-off-by: George Cherian <george.cherian@ti.com>
> >>---
> >>  drivers/usb/dwc3/core.c | 31 ++++++++++++++++++++++++-------
> >>  1 file changed, 24 insertions(+), 7 deletions(-)
> >>
> >>diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >>index c35d49d..d5e6f3e 100644
> >>--- a/drivers/usb/dwc3/core.c
> >>+++ b/drivers/usb/dwc3/core.c
> >>@@ -100,7 +100,9 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
> >>  	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
> >>  	usb_phy_init(dwc->usb2_phy);
> >>-	usb_phy_init(dwc->usb3_phy);
> >>+
> >>+	if (dwc->usb3_phy)
> >>+		usb_phy_init(dwc->usb3_phy);
> >I would feel more comfortable if you would move our maximum_speed module
> >parameter to DT with a property such as:
> >
> >snps,maximum_speed =3D "highspeed";
> >
> >then on driver you could:
> okay
> >ret =3D of_property_read_string(np, "snps,maximum_speed", &maximum_speed=
);
> >if (ret < 0)
> >	bailout();
> >
> >if (strncmp(maximum_speed, "superspeed", 10) =3D=3D 0) {
> >	/* grab USB3 PHY, return EPROBE_DEFER if not found */
> >	grab_usb3_phy();
> >}
> >
> >if ((strncmp(maximum_speed, "highspeed", 9) =3D=3D 0) ||
> >	(strncmp(maximum_speed, "fullspeed", 9) =3D=3D 0) ||
> >	(strncmp(maximum_speed, "lowspeed", 8) =3D=3D 0)) {
> >	/* grab USB2 PHY, return EPROBE_DEFER if not found */
> >	grab_usb2_phy();
> >}
> >
> >this way, we depend solely on setting maximum_speed to highspeed for
> >AM437x :-)
> In dra7xx one instance is superspeed and one instance highspeed.

right, but in DT you will define both instances and each instance will
have a seaparate snps,maximum_speed attribute :-)

I'm now considering if we should make maximum_speed a generic attribute,
Kishon ? Alex ? Alan ?

anyone else needs such thing ?

--=20
balbi

--vDpvzslK0qRw06MN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRytqaAAoJEIaOsuA1yqREFFgP/jVlUkSuc3I9GaHkmBwbOXM6
pnHEGTsd0eJMwucS/qmzXzJrDNOoaUnPfM17Z0LNmLaMNfpRmQoJ48MKnyaLmPUV
oRryTMqwjEMtPu2fNGSvDuTsLsK15C4cTI8uh49Z1w8CQLu/KafvyVP+ci2qlY55
NZdm7mj5Qja4dSR9d5j+Omv0T07ZO75MqA7UStyc2LU+0gBg1ySylXBSsSD2/Mcs
1jU9Mu8KOoSlrsUW1ARr61lYrr1PHmnbcN5uJ14N8DwCP7RsQBIa5KVdpJDUdl6+
CHZu0PKOCF7EVW7cV1WUXgaK1li5ZopNYpYe6LC4DjU7vkrM28f73EB3RRp2xpQZ
Zqr3QXFRiC3XoekIyB7TRIpvo7RG9I64w9vXwMI8Ob2Jb/YSfKK1aZfjRVylzyE6
zICohp85ZJSY5Uzq0JVM452J7AW+0+KgR8LNSPXtSyUMKK+hK37Av6Dxj7uWSTDh
9zUIZpmmyJ3dXCi4cMpQ5/4YGWuYqp4bIFls8Z06OKoSb/r5xNReXufKlU1Kuyax
OjM++QH4UekY19fV2rfSTkap9MXe6quUDVzUb92TN2K4aZ0f2ryUZ7lJgHCSpDGJ
9chQAzGqqfs1vgAIX6Fq1yTvZ3CvDteV4xejKOkVp2isKVe5Y+qUElO1W8xPVDNN
FkZgFA9g6ZNlJLzbPu/5
=bNYL
-----END PGP SIGNATURE-----

--vDpvzslK0qRw06MN--
