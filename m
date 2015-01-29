Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbbA2FEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:04:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48193 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbbA2FEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:04:06 -0500
Date: Wed, 28 Jan 2015 23:03:55 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 7/8] phy: helpers for USB ULPI PHY registering
Message-ID: <20150129050355.GB9098@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-8-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <1422025978-178336-8-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 05:12:57PM +0200, Heikki Krogerus wrote:
> ULPI PHYs need to be bound to their controllers with a
> lookup. This adds helpers that the ULPI drivers can use to
> do both, the registration of the PHY and the lookup, at the
> same time.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/ulpi_phy.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 drivers/phy/ulpi_phy.h
>=20
> diff --git a/drivers/phy/ulpi_phy.h b/drivers/phy/ulpi_phy.h
> new file mode 100644
> index 0000000..ac49fb6
> --- /dev/null
> +++ b/drivers/phy/ulpi_phy.h
> @@ -0,0 +1,31 @@
> +#include <linux/phy/phy.h>
> +
> +/**
> + * Helper that registers PHY for a ULPI device and adds a lookup for bin=
ding it
> + * and it's controller, which is always the parent.
> + */
> +static inline struct phy
> +*ulpi_phy_create(struct ulpi *ulpi, struct phy_ops *ops)
> +{
> +	struct phy *phy;
> +	int ret;
> +
> +	phy =3D phy_create(&ulpi->dev, NULL, ops);
> +	if (IS_ERR(phy))
> +		return phy;
> +
> +	ret =3D phy_create_lookup(phy, "usb2-phy", dev_name(ulpi->dev.parent));

I wonder if this would break DT-based boot where PHY phandle is
available. Kishon ?

--=20
balbi

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUyb87AAoJEIaOsuA1yqREPhIP/0xy+K1RSgkhYrDIFEL3zRjD
Cs2l7VnYQlVxP+Wl3+VuTk/g+HaSvIjwTlkY4AuEo6w8qZ8YA58mqcUFU4H/FbXC
iC30pYAlskRgsTUwxU5Oty6aADcpoYT2UlxCbMgYzrZRU4nbAIRwU3Pq+7cWE/Sr
IxTQIe7ixwyXdafFDKWTEQVRFLPIvo9hlGwY1rSlXwOQN5W+uxD2/zvBW7TgIsHT
sdo4a66OJnYdwx2wqMuNcDb5+L25fTV0U+lVVAecD/L2vorgPnsyQq52RDnlSCz4
nArCqeq1sMUDpHWqXoHw3C/anViqea9iie7rUKI3pyVfTn79PMlVSQYheJ8tRlte
TX1gerzLfCG4PrlhpLH7Kll/3lFZTa6HRqcx6B1Wv8tFwHF1tyqf4+Zy3QecBcdW
xHuxoe3jSYmSsZGs3oJf+XR0UrF2hour0iZUIJqaAMc36KdBCyY/VRtRGkYCp7Aa
hKQm4tMN4dwCpYnLbXjIpPbLtZAnOv0qZnMaqy+P0Mb30TRd4c5AJzdZXhymfK2i
J0J+Zh9VhjbVZkB2oHTuyAJV3BDdPwTqloE7OQ7tNkOfiuxHuOR5STTiQ7thwA94
CErtJXLCAmLZNhURpAHGGz36Alh9IK9NSgDBghuIlHdQkVf16Kguglmil0jHN+Km
lVr46LCGwox841chgIvC
=216y
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
