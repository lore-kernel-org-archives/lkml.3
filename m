Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3CEPGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:06:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55952 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab3CEPGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:06:33 -0500
Date: Tue, 5 Mar 2013 17:06:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>,
        <gg@slimlogic.co.uk>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: dwc3: dwc3-omap: return -EPROBE_DEFER if probe
 has not yet executed
Message-ID: <20130305150608.GI12123@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362493320-13913-1-git-send-email-kishon@ti.com>
 <1362493320-13913-3-git-send-email-kishon@ti.com>
 <20130305145645.GG12123@arwen.pp.htv.fi>
 <513608E6.3010502@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K1SnTjlYS/YgcDEx"
Content-Disposition: inline
In-Reply-To: <513608E6.3010502@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--K1SnTjlYS/YgcDEx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 08:31:58PM +0530, kishon wrote:
> Hi,
>=20
> On Tuesday 05 March 2013 08:26 PM, Felipe Balbi wrote:
> >On Tue, Mar 05, 2013 at 07:51:58PM +0530, Kishon Vijay Abraham I wrote:
> >>return -EPROBE_DEFER from dwc3_omap_mailbox in dwc3-omap.c, if the prob=
e of
> >>dwc3-omap has not yet been executed or failed.
> >>
> >>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>---
> >>  drivers/usb/dwc3/dwc3-omap.c  |    7 +++++--
> >>  include/linux/usb/dwc3-omap.h |    6 +++---
> >>  2 files changed, 8 insertions(+), 5 deletions(-)
> >>
> >>diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> >>index 19c6e72..9428f4e 100644
> >>--- a/drivers/usb/dwc3/dwc3-omap.c
> >>+++ b/drivers/usb/dwc3/dwc3-omap.c
> >>@@ -138,11 +138,14 @@ static inline void dwc3_omap_writel(void __iomem =
*base, u32 offset, u32 value)
> >>  	writel(value, base + offset);
> >>  }
> >>
> >>-void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
> >>+int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
> >>  {
> >>  	u32			val;
> >>  	struct dwc3_omap	*omap =3D _omap;
> >>
> >>+	if (!omap)
> >>+		return -EPROBE_DEFER;
> >>+
> >>  	switch (status) {
> >>  	case OMAP_DWC3_ID_GROUND:
> >>  		dev_dbg(omap->dev, "ID GND\n");
> >>@@ -185,7 +188,7 @@ void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_statu=
s status)
> >>  		dev_dbg(omap->dev, "ID float\n");
> >>  	}
> >>
> >>-	return;
> >>+	return IRQ_HANDLED;
> >
> >IRQ_HANDLED ????
>=20
> Actually I did it that way since palmas_vbus_wakeup_irq can directly
> return the return value from dwc3_omap_mailbox. If this seems hacky
> to you, I'll change it.

it does seem hacky :-) Try something like:

ret =3D dwc3_omap_mailbox();
if (ret)
	print_error();

return IRQ_HANDLED;

--=20
balbi

--K1SnTjlYS/YgcDEx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNgngAAoJEIaOsuA1yqREGlAP/07bVU5jAR8WevcZqDwVHQOk
cQ+qaga70LtxkcaXCyo/K9cxRaajRtTApAHMYe66R5zzmRALzTMaAlZfUdhVvL4s
D/K0vnINLdrLaqEzv4+oILh3WJIjd3+4Nc5xzDW3ue6+C5uQ06HZLSMHQbS/DGck
6HMHar7E+C7eK17W8Pkbs5xFwBeZQc79Mk8Ab/MUbXOi+iV70NLrETnsPA8Sp6cA
bUIuAj+Yd0a8xgAl1rWL2EEhgSktq6nBeGKGfDY6m5MaNPNF/YZ4MzIw2uGv11lO
KLrXO7sJU+MdwDbl3wHbKYZ6q6qnT3c6Vy/+6OH+6uTCQ/15xBJjyWuZWUkhR/ru
vZEe1D9Z3vqQlNU8mpeM4s2+h5UL17S3HZ7J3mdhoojQT8VugMKej+bh15JDkX6/
Z3RED4nxQAjzlQIFF1v51yPITu7HfyVSx338xMDI8EUw57ucBsiXZzN2OALnK9VS
NlWgUgQ0UpwmzBonoqHtovDAn7TgZykLAcXopzcum0EjrWIUHtl3GMxjyZ3fMfwx
o2II6CkFqLAFydAtFMaj1aOxcc33ra3I2Vhj3CvuuxhXkOj1NGMhateBr8FHb0od
cTKtYohf1BS88uRt8IKw0um0FYhOY7OZmDuvLemB/lnMbqzKQ6WSSYsVDcZg1tVT
/rIjoPEH6tkDdWGy5ub8
=seLA
-----END PGP SIGNATURE-----

--K1SnTjlYS/YgcDEx--
