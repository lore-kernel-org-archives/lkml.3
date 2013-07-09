Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3GILaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 07:30:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33137 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3GILaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 07:30:13 -0400
Date: Tue, 9 Jul 2013 14:29:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <arnd@arndb.de>, <adrienverge@gmail.com>, <kishon@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v3 1/2] USB: PHY: Make PHY driver selection possible by
 controller drivers
Message-ID: <20130709112948.GJ5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371203502-29624-1-git-send-email-rogerq@ti.com>
 <1371203502-29624-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DesjdUuHQDwS2t4N"
Content-Disposition: inline
In-Reply-To: <1371203502-29624-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DesjdUuHQDwS2t4N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 14, 2013 at 12:51:41PM +0300, Roger Quadros wrote:
> Convert PHY Drivers from menuconfig to menu so that the PHY drivers
> can be explicitely selected by the controller drivers.
>=20
> USB_PHY is no longer a user visible option. It is upto to the PHY
> drivers to select it if needed. This patch does so for the existing
> PHY drivers that use the USB_PHY library.
>=20
> Doing so moves the USB_PHY and PHY driver selection problem from the
> end user to the PHY and controller driver developer.
>=20
> e.g.
>=20
> Earlier, a controller driver (e.g. EHCI_OMAP) that needs to select
> a PHY driver (e.g. NOP_PHY) couldn't do so because the PHY driver
> depended on USB_PHY. Making the controller driver depend on USB_PHY
> has a negative effect i.e. it becomes invisible to the user till
> USB_PHY is enabled. Most end users will not familiar with this.
>=20
> With this patch, the end user just needs to select the controller driver
> needed for his/her platform without worrying about which PHY driver to
> select.
>=20
> Also update USB_EHCI_MSM, USB_LPC32XX and USB_OMAP to not depend
> on USB_PHY any more. They can safely select the necessary PHY drivers.
>=20
> CC: Pavankumar Kondeti <pkondeti@codeaurora.org>
> CC: Roland Stigge <stigge@antcom.de>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> [USB_LPC32XX part] Acked-by: Roland Stigge <stigge@antcom.de>
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

There is one problem (?) with this: phy-core.ko will never be a module.
If that's not a problem for anyone, I guess this is safe to apply. I'll
wait a little longer until merge window closes to give people some extra
time to shout.

--=20
balbi

--DesjdUuHQDwS2t4N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2/QsAAoJEIaOsuA1yqREtnsP/3+RCqW7V/LL7OV1/2kcDfO8
3jt2N0bq+t23D6Mb3BCq7ePQtTCRzyG+hVaNzp263NbIntxeboF0R4DudJkf5i0N
QB4Box0bpdbOhYaUGOxGvQ8NlWZwg61raWsorHJIf2CCtKbHCv5FkLcSWsbdcPof
q4OhVJo3joDXEP7Pf2z6FEKaFRkp9ch7MnQEbguyhLLerpgidMI+epOiDPNMzt7x
nKfTTRUxD3fhlUerNqNyhUpidvltAUYxWG74gYzR7VsOGOZEirQb/DN3zZorUIkD
BEY+1EMxFYC1EnP7a/bBjNX7+36liqFJmidsSkXrgk3Y0P5y5auw2qqujK3mv6iU
o6RnhMcATcpX7itfjZv6ZACrn2+Da8g9RvQ/VbpZNS8/y44W1vRxfbDlImBG8p79
wpR9I2fkmYGfhbJ0erxYBHn/Vaiu+ipZG0nSkbhYSN+1Yvkq/2w0GmRZRJNvB7k9
Nody7tU2Soe+XT679yvA+RTRK1RVZilmyQUF3hDZiySlDWcqL8JBG7trXqgoRa66
X0ZFRqjKEWguNg21vckXHY+JyJe1DYRsRe8NOk7q51NEAmdsii6e+/a/fAIlPH3s
3ZJpBVJtLwSeyhv5Q1aPcyovDeEnfM1aIvV7eqifsuUKoqQON1HHzXmmAKaAokMl
jKm41VX9jXDocpBFlLcr
=bkAS
-----END PGP SIGNATURE-----

--DesjdUuHQDwS2t4N--
