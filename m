Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaHUTSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:18:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60466 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaHUTSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:18:15 -0400
Date: Thu, 21 Aug 2014 14:18:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: <tj@kernel.org>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <linux-ide@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ata: ahci: tegra: fix build error
Message-ID: <20140821191806.GN11146@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140821190824.GM11146@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JfVplkuTfB13Rsg5"
Content-Disposition: inline
In-Reply-To: <20140821190824.GM11146@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JfVplkuTfB13Rsg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 02:08:24PM -0500, Felipe Balbi wrote:
> Currently, ahci_tegra doesn't build because it includes a file that
> doesn't exist.
>=20
> The problem is that first commit 306a7f9 (ARM: tegra: Move includes to
> include/soc/tegra) renamed include/linux/tegra-powergate.h to
> include/soc/tegra/powergate.h.
>=20
> Later commit 7232398 (ARM: tegra: Convert PMC to a driver) renamed
> include/soc/tegra/powergate.h to include/soc/tegra/pmc.h and neither
> commits fixed drivers/ata/ahci_tegra.c.
>=20
> Fix that so the driver has a chance of building. With current kernels.
                                                 ^
						 this period shouldn't
						 exist :-p
>=20
> Cc: <stable@vger.kernel.org> # v3.16
> Signed-of-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/ata/ahci_tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
> index fc3df47..7194835 100644
> --- a/drivers/ata/ahci_tegra.c
> +++ b/drivers/ata/ahci_tegra.c
> @@ -24,7 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> -#include <linux/tegra-powergate.h>
> +#include <soc/tegra/pmc.h>
>  #include <linux/regulator/consumer.h>
>  #include "ahci.h"
> =20
> --
> 2.0.1.563.g66f467c
>=20
> --=20
> balbi



--=20
balbi

--JfVplkuTfB13Rsg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9kXuAAoJEIaOsuA1yqRE0xAQAKnEQcNJcNru3tT0r/rPGS7U
Oddv2UqxtqGwhgPnSy7y7xcGAdYySlf/wepB4Jvh41NB9O7Vk1VWtJ+oZO8imV1r
gBm1QbzBDHxn2FcHXFTm9hfb49/HOOKV49rP30PJF9EHB+qpWxoYu+uVk+/CWMu1
aNDvOxWEIo5fqwkqJUQZj0U2tU9F054Yj1GLadZxDhqZpZm9l1/0KdmAYcC3Wrqy
gKbsSYNj+gYMj4bsogMjud+IHk0Of/aWSyIETxEoUjzhQkla3Bx/rkNic1KGnn5r
OA1zVEgMSkboj/6pKI28+CnMyqHLbnslIXxFWkxPaHpCaAjm74T0iGHXXlsQk+ai
kGFRhXh5lI2xLv8RCFUyVy3lc6ldbQ/9tYAJ7faDTExdHQMSBWgoE5iLC+052Sn8
1r9udkLJv7uiNLU+UT5Ze3dDLfE0/pZJouyPMTBjz33R6K13PIrCktuHN3B6/ka0
iPi9RmWbkF/9P5komeYgWufrcRQBARnjBBJSG4a1zQPkztzb2b/1NiePnKudki8Q
cOpP4F26jYixLkyAlieGhvSIHHPImBAAF6kI0A3wdKwlw8JtoTtfQAtQ0cHTy0bb
mFcYm1ZWDXKUWYdVB84Wt3SvksabJFb7OKZ18cGSAClFfpHcRCX2ykMW7ngBTHcM
oZzKlhUBF3C89llbuijX
=CyeL
-----END PGP SIGNATURE-----

--JfVplkuTfB13Rsg5--
