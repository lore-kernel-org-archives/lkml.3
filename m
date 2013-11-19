Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3KSBoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:44:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48892 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KSBoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:44:09 -0500
Date: Tue, 19 Nov 2013 12:43:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: linux-next: manual merge of the gpio tree with the pm tree
Message-Id: <20131119124357.a6191743b0f568d40c8291d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Nov_2013_12_43_57_+1100_=kZeRQy5826sBfi0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Nov_2013_12_43_57_+1100_=kZeRQy5826sBfi0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/gpiolib.c between commit 7b1998116bbb ("ACPI / driver core:
Store an ACPI device pointer in struct acpi_dev_node") from the pm tree
and commit f760f1967ee8 ("gpiolib: use dedicated flags for GPIO
properties") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpiolib.c
index 4e10b10d3ddd,48d1a67ed488..000000000000
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@@ -13,7 -13,7 +13,8 @@@
  #include <linux/acpi_gpio.h>
  #include <linux/idr.h>
  #include <linux/slab.h>
 +#include <linux/acpi.h>
+ #include <linux/gpio/driver.h>
 =20
  #define CREATE_TRACE_POINTS
  #include <trace/events/gpio.h>

--Signature=_Tue__19_Nov_2013_12_43_57_+1100_=kZeRQy5826sBfi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSisJhAAoJEMDTa8Ir7ZwVK6cP/3FoZjxUJgXaeH0rwJZJqOCP
CcreoXBl9xBvX1f/pSaG8XZ+qdJ++ms/hR0zXVjMDrznucc/3DxI2y1hpAr2oMXf
ceQPRzFv4ZIShKpeJGIHvZCuUENa16MiY+EMJbNfb1cM4h3DDZz5bzoclr/uIoTv
MuIIEeI/mpi96HdOFaXxCHpYdIfoRcd1efbHWZ0IXVcTIffEIbtMnfK7S9SFhy3O
yC+dWy2AZ3Gll5H565yG9CzKaSulO8O+ZpO9qsU59QS3scWSEcT7KvgfQK4vcCSw
twDOhtFYBsiklNbBnmRP4L5PyzP0csTsf/HtHgmIzLGzvRV6TPCDeTM3gH3U84+u
Oty2Orlh7DE38xITOqn1INrBSgkrVlVh4aG7BBsRiw+dIQlQif2NXmJVv1pLcywN
TTDRqBqYsSokZ6x0EOWTxGDzu0yOfb+XplsUqymg121jczxsWMCkA3tkg5wMZwwe
lBffsCKXZK65O4OTlv36Kwcq3JJQhBdcoPj33a8T1NOzcXZDACip5svXb7y2s6LX
c7o9x9koiKYegeUODmX1KsyOdg+eibHpFZCXwPmxYygp0GZG82fBSonElbv3ei0x
O8UXwSt9W7KlAo4Qib//RTGj4hmf7vQzBAfbn5RD5I1Cbm+N3NZqfgb03cRCXXeM
hOFGmfGveXTQyrsMzisC
=Zx0D
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Nov_2013_12_43_57_+1100_=kZeRQy5826sBfi0--
