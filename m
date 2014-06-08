Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaFHDCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 23:02:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39372 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753207AbaFHDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 23:02:36 -0400
Message-ID: <1402196538.23860.24.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.14 186/228] PCI: Wrong register used to check pending
 traffic
From: Ben Hutchings <ben@decadent.org.uk>
To: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Sun, 08 Jun 2014 04:02:18 +0100
In-Reply-To: <20140604232354.004988520@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
	 <20140604232354.004988520@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ku9j6oJri/88Jd58p1gw"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ku9j6oJri/88Jd58p1gw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-06-04 at 16:23 -0700, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Gavin Shan <gwshan@linux.vnet.ibm.com>
>=20
> commit d0b4cc4e32705ff00d90d32da7783c266c702c04 upstream.
>=20
> The incorrect register offset is passed to pci_wait_for_pending(), which =
is
> caused by commit 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor
> pci_wait_for_pending_transaction())").
>=20
> Fixes: 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor pci_wait_fo=
r_pending_transaction())
> Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Alex Williamson <alex.williamson@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/pci/pci.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3043,7 +3043,8 @@ int pci_wait_for_pending_transaction(str
>  	if (!pci_is_pcie(dev))
>  		return 1;
> =20
> -	return pci_wait_for_pending(dev, PCI_EXP_DEVSTA, PCI_EXP_DEVSTA_TRPND);
> +	return pci_wait_for_pending(dev, pci_pcie_cap(dev) + PCI_EXP_DEVSTA,
> +				    PCI_EXP_DEVSTA_TRPND);
>  }
>  EXPORT_SYMBOL(pci_wait_for_pending_transaction);
> =20
> @@ -3085,7 +3086,7 @@ static int pci_af_flr(struct pci_dev *de
>  		return 0;
> =20
>  	/* Wait for Transaction Pending bit clean */
> -	if (pci_wait_for_pending(dev, PCI_AF_STATUS, PCI_AF_STATUS_TP))
> +	if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
>  		goto clear;
> =20
>  	dev_err(&dev->dev, "transaction is not cleared; "

This still seems to be broken because pci_wait_for_pending() does
pci_read_config_word() but PCI_AF_STATUS is not word-aligned.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-Ku9j6oJri/88Jd58p1gw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5PSP+e/yOyVhhEJAQqKsxAAxo1EbIMMcZewIY9JdFNSPXUC3kZVbDhc
UJU/vbx5dFxplejijs7YeMhUwiPVCd40CJaV+hW3CaKWgaEhrDXSAlzMpqbZt0uv
IwTV9JBzqPijNkco5sCZI+/w84R2lusaFqS6YRPyL8EV2/w7yXVuaSv31+9JZKQs
P6zfWnDzso3lEoPesvpDiyGKFd6/YlgeBIQttFukyVbLnue2kagexjJj5/b51EWT
HTFOhMqjxFJ3x3u/9Ltwj1Prk+cltux+/Qujc930b4fjwvbOqGwgs3I9J+gd8Crw
DST4/W+NMoFnrrOwn8lsgveDlpzSTslLT3UU0Lo3dY1dHehvMh+mA5E2WDZjpH3U
/XG5iRst0TKue/Pt5NVSQAt/lTxt8aZ3EgvUv/pPXNSYi1DGN+K70uyCOHyK5GWT
hZpXnNA9qznel9NeW7hcda2kds3IcXB2Oe96+eXXuSlnG8dfDUExblHKxLXCDfrH
61a3OuJZg/G45vWl7JeIUBNu2bRumH0yqHQ9A2NQ+oj08IzOZM1X2BzsAsWwmDXr
9Aj5MFrdvwligGW+Vjp3xtRX/4F9nyUGz72r0FaBnbNXx6WjLf1ExL/lVhUEYyQu
C5E4wquO+6+LUt/jfsqxhcMlTBryje3zQ5lY1tCJE8cXWhkSHqRWr+sMAjVmqmwS
VlYpqYEHYCs=
=DDsP
-----END PGP SIGNATURE-----

--=-Ku9j6oJri/88Jd58p1gw--
