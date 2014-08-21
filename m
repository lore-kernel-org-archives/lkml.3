Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaHUTIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:08:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44907 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbaHUTId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:08:33 -0400
Date: Thu, 21 Aug 2014 14:08:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: <tj@kernel.org>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-ide@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ata: ahci: tegra: fix build error
Message-ID: <20140821190824.GM11146@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNG1vEeyG8BCaHbQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hNG1vEeyG8BCaHbQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Currently, ahci_tegra doesn't build because it includes a file that
doesn't exist.

The problem is that first commit 306a7f9 (ARM: tegra: Move includes to
include/soc/tegra) renamed include/linux/tegra-powergate.h to
include/soc/tegra/powergate.h.

Later commit 7232398 (ARM: tegra: Convert PMC to a driver) renamed
include/soc/tegra/powergate.h to include/soc/tegra/pmc.h and neither
commits fixed drivers/ata/ahci_tegra.c.

Fix that so the driver has a chance of building. With current kernels.

Cc: <stable@vger.kernel.org> # v3.16
Signed-of-by: Felipe Balbi <balbi@ti.com>
---
 drivers/ata/ahci_tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index fc3df47..7194835 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -24,7 +24,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
-#include <linux/tegra-powergate.h>
+#include <soc/tegra/pmc.h>
 #include <linux/regulator/consumer.h>
 #include "ahci.h"
=20
--
2.0.1.563.g66f467c

--=20
balbi

--hNG1vEeyG8BCaHbQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9kOoAAoJEIaOsuA1yqREY2QP+gM4lEUl2NR+MlMhdak9rem0
ibFSJYKkdMZXJJt2XTgBnUzMmuoiBwAXAWN7LFFHq+dQwmHd0upZUDwEkyJS5I7Z
p7oIs7hH4VOWbCWdPQJtRy42nwAFGJqBiB00JniIsmyqtM/gwnTwpJfWouO0SBvY
e2xPdQspPbE4ruK1OXKAFbaVHTRVm11rhtfLxE5Ow6CfsSWemRgf5v2FnD1vdnZ1
p6wVwj4vyE1Ia8UyUSYH4+TA9T3kXeIPHZR9kqWE4jiW9JMYnyIUgzZAGvdqPyL2
Tz4Oe7cYehZVCnstbhCCsPWBUy6qSbDrMi0WYKlDVGDH9+R37tmoT8IGJ4RXXcmP
dgE5Zcb2ernEQiD6ZxGLCUxfltLnZG3bPiCWPMtwI5VXLINPRAafMf2iYGEtM0zL
DS9EUE0jk0FD4+2dkx0nYk5A6Ag2IhJAQSn76Jz0IdQrxNb+K9zqHA2dN0PSd9z9
PPlCzDjrpwxRQgcoP9D3plLo32ybwy/jO4sygq907KV69aZFGG7XyWh7/9bmBfB0
5XV0YhZ1tmiLH2TBQ/DEitUiN/CLJrNeuCgmM/6qhKoGefyopBMqxlF78UBlDGQB
N6d6DaTAmCVO1sddEvVOd0D32fe86ugnLcxdu3/8mbG8pPrv3RGsFsh+RMBMNqWc
g8xd0db96ITxPVj8W+Fy
=jOn+
-----END PGP SIGNATURE-----

--hNG1vEeyG8BCaHbQ--
