Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456Ab3DBHKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:10:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58538 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab3DBHKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:10:51 -0400
Date: Tue, 2 Apr 2013 18:10:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>, Wolfram Sang <wsa@the-dreams.de>,
        Danny Huang <dahuang@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the i2c tree
Message-Id: <20130402181041.067483395c622b627826fed9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_18_10_41_+1100_aT/F0BCLAdiIGVNL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_18_10_41_+1100_aT/F0BCLAdiIGVNL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/tegra.c between commit 49a64ac555f1 ("i2c: tegra:
assume CONFIG_OF, remove platform data") from the i2c tree and commit
d591fdf8e23e ("ARM: tegra: expose chip ID and revision") from the tegra
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/tegra.c
index 6e1c9a9,84deeab..0000000
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@@ -30,6 -31,10 +31,8 @@@
  #include <linux/pda_power.h>
  #include <linux/platform_data/tegra_usb.h>
  #include <linux/io.h>
 -#include <linux/i2c.h>
 -#include <linux/i2c-tegra.h>
+ #include <linux/slab.h>
+ #include <linux/sys_soc.h>
  #include <linux/usb/tegra_usb_phy.h>
 =20
  #include <asm/mach-types.h>

--Signature=_Tue__2_Apr_2013_18_10_41_+1100_aT/F0BCLAdiIGVNL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWoRxAAoJEECxmPOUX5FEz0sP/2vROtB0T7AsDG4RIZ7NS98S
oWwIPOkNF89vW50jM6Jos9p7MjGtEhSszyIz4PUutvrW2ltIgoxc7HF4rp64U9tR
KI4qmrNvwQq/mcNqEi3am2o/bgYkEbS7ehW/79vOh+BHOFp8kiYORe49M8Lpgc6A
KXhIamPcv1MbniIbp6XXx+r3tIk8Jc2S9FpsM8MP1ekUjlnr131ChDBD53w8KUFv
pujRJXEF4XwkmG0JsbYFWZo9/UODELMSQIB6LdiukNWOhPsXvZi6Vm9xLa0O9mln
2V3DqrIaQKXrNNsd71xhOYWQwwsYZrpqB9OhVv6RZ7RE0iXg2Fc2Dl0h78k6jTef
huSL//4V6bTFvyhFLpO96+B92aZjGX9+X/Oae04sz/jZS+6Uk3aA24ux3xDVDf0+
EoOUij7mPMOVypOk+ij/ThL6cTdFLf/bhY0AhCoi9gCrnKfazczdK8211BnvJ3Uy
AZNKez61Y8K+GmDt2hIlTTJQgl4sMb1niJyPK9qjz3LjXCXPCrT7mVCmqJLntpfw
/d6YjH/22o7qNx+MOKa9qhBgCK5ycgGGlPTqz8b7yU45/YrZwDPJF3CupB5ajikk
CGgLkv027pNc9irIaCG9+3T7Lc8jgxKfxI46Zu72cVPhHZykN2s3kWXE5Wf+Hz7F
rppZJVdSFMPOTtAFXHdQ
=y18W
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_18_10_41_+1100_aT/F0BCLAdiIGVNL--
