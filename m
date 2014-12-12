Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbaLLFKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 00:10:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51491 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918AbaLLFKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 00:10:17 -0500
Message-ID: <1418361002.3599.79.camel@decadent.org.uk>
Subject: Re: [PATCH 1/2 v3.2] mei: add mei_quirk_probe function
From: Ben Hutchings <ben@decadent.org.uk>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Fri, 12 Dec 2014 05:10:02 +0000
In-Reply-To: <1417472994-19699-1-git-send-email-tomas.winkler@intel.com>
References: <1417472994-19699-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9n7JlUaL4Z7vupSNcxz+"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9n7JlUaL4Z7vupSNcxz+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-12-02 at 00:29 +0200, Tomas Winkler wrote:
> commit  9a123f19832702753805afe0e93db26799b91b07 upstream
>=20
> The main purpose of this function is to exclude ME devices
> without support for MEI/HECI interface from binding
>=20
> Currently affected systems are C600/X79 based servers
> that expose PCI device even though it doesn't supported ME Interface.
> MEI driver accessing such nonfunctional device can corrupt
> the system.
>=20
> [Backported to 3.2: files were moved]
> Cc: stable@vger.kernel.org #v3.2
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I've added these two to the queue, thanks.

Ben.

> ---
>  drivers/staging/mei/main.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>=20
> diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
> index eb05c36f45d4..44ed7a859ecd 100644
> --- a/drivers/staging/mei/main.c
> +++ b/drivers/staging/mei/main.c
> @@ -106,6 +106,27 @@ MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
>  static DEFINE_MUTEX(mei_mutex);
> =20
>  /**
> + * mei_quirk_probe - probe for devices that doesn't valid ME interface
> + * @pdev: PCI device structure
> + * @ent: entry into pci_device_table
> + *
> + * returns true if ME Interface is valid, false otherwise
> + */
> +static bool __devinit mei_quirk_probe(struct pci_dev *pdev,
> +				const struct pci_device_id *ent)
> +{
> +	u32 reg;
> +	if (ent->device =3D=3D MEI_DEV_ID_PBG_1) {
> +		pci_read_config_dword(pdev, 0x48, &reg);
> +		/* make sure that bit 9 is up and bit 10 is down */
> +		if ((reg & 0x600) =3D=3D 0x200) {
> +			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
> +			return false;
> +		}
> +	}
> +	return true;
> +}
> +/**
>   * mei_probe - Device Initialization Routine
>   *
>   * @pdev: PCI device structure
> @@ -120,6 +141,12 @@ static int __devinit mei_probe(struct pci_dev *pdev,
>  	int err;
> =20
>  	mutex_lock(&mei_mutex);
> +
> +	if (!mei_quirk_probe(pdev, ent)) {
> +		err =3D -ENODEV;
> +		goto end;
> +	}
> +
>  	if (mei_device) {
>  		err =3D -EEXIST;
>  		goto end;

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-9n7JlUaL4Z7vupSNcxz+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVIp4rue/yOyVhhEJAQo3pA/8DqcDox1GeyN5QGlGWYIml2d5T06EkidU
jA0takUJerIHuvJ5SisIgXTcV/JFxjW0jDM6H4GcaMmk+iPwLRycC9yMMQibyQKT
x/Keg0A0EllLssrL2fYViqMjCsdjz+zkl/82ISNLtR3cITOOhcF6C2Q44ZQztuUG
DAThxiKYNRPUdUoCP7YA+i52/KS94X/A6XhADYYsYcKDJKJyb+1yGvbzoJgCFcCs
mTsoYUaD/8xFUBGvKWJEfuwCfsdhTGoWXBVoWJYOd2V7qSSS2TpDpbFkSbOTDhOi
i+dzUZw5wxwaUZ85TizBh9NTSKAdhWnzkoQctBpx/WmvbRFvr7O+P/JxMcoMzzkR
1RcRDavaEoLOOTYzHN1K/n9fPSXM820xjhA55eMDbnWpLVye+/twou8ibfFmP0Nt
Z/74u1Rmdf5W1NcdzeBqQM6SDNAgkLLVihwmiEt/YT3Bbh1yCMHmEGOt00MQ0+mV
Jt0GVoy94EB62weA7W0MOCobFDUwjMCwnUmtux/b9ahypbuyJX9xNVaB+ShIq5QX
Ua7qqLmHpDmGKFKYLPOdv3olVBdp5+JCHyHfe9Uy/Q9N4FAvLN6dK6W8P6rxM+Yu
54dtzdXo3ZRcQXGAKe+ttj1blCFyrxsgcSV7irRlPb4kLoKkNW1zkg4ZUOXK6YF2
MDYmB2MjYsE=
=8NCU
-----END PGP SIGNATURE-----

--=-9n7JlUaL4Z7vupSNcxz+--
