Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaG3I5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:57:19 -0400
Received: from ozlabs.org ([103.22.144.67]:53271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaG3I5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:57:16 -0400
Date: Wed, 30 Jul 2014 18:57:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kim Phillips <kim.phillips@freescale.com>
Subject: linux-next: manual merge of the clk tree with the driver-core tree
Message-ID: <20140730185708.12a99f00@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MJAAzOcNE.bvnm./NZ5_ffa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MJAAzOcNE.bvnm./NZ5_ffa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/base/platform.c between commit 3d713e0e382e ("driver core:
platform: add device binding path 'driver_override'") from the
driver-core tree and commit 86be408bfbd8 ("clk: Support for clock
parents and rates assigned from device tree") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/platform.c
index 7cc7440b014d,ac47643b1b69..000000000000
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@@ -23,7 -23,7 +23,8 @@@
  #include <linux/pm_runtime.h>
  #include <linux/idr.h>
  #include <linux/acpi.h>
 +#include <linux/limits.h>
+ #include <linux/clk/clk-conf.h>
 =20
  #include "base.h"
  #include "power/power.h"

--Sig_/MJAAzOcNE.bvnm./NZ5_ffa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2LNpAAoJEMDTa8Ir7ZwVw3kP/0UlwnmAVLXXbFNRqViOGjmm
WubjNEvHVqtZM76G2/OXI91jfVrugEdkPEG6wPVuNKrTJI4YH8mBFb6o5VCI9hAa
pUrQN7op2h/5ci7Z4WkyEJC6wET26MTZq9qG2et4cyAXsfvMOSIFdVjPHGOqAnSU
zl7IFg0RwLJi6ahNcSHnqMt1J3q9pv8XUqYQl11KxbtGu5CGlBbL5vMMOh0/Giw0
YI1vAlPwQorAJt1OIePQybw+s5SolLtt3Gfeh+R4YCIcsbk8moHQxv26gRNv24kJ
+8w7H1vD7ddMoVTyWYgBelZ5yJM4GB2kC85sfzx0241J/HdT9SLFun9fdCFrStY/
aTti2KkJgDNWWq3uMowzsgxd5lOJ/gexZ9uWjY+14flC+ObviiKWLwpldMx6LxAL
p8elqfxs0EPVB3tQ449GiBOcuQBJ1/n0FVrje283pTszGBcfhVQXeuO2hvTb+rkq
zW11730skj8btkPaoxitwivcNca6OMPAEmYsH2wadpTdBxDW0MWp321PSFqKIfqw
CuvTdnTUMfWHKyA0d8K4SR1iEyCa7gtc5E4lsKSKEPnYWQXXMaJ04Kxm6N+aQGAD
viPPt5DWoNBEu0vIO9uTaiuxpTxxRXn2xe7pyjNTQ+HDGq9HA1ZdCGFzHKlqJvd6
IEDTY23y4TfXViwCWVtj
=M3Q5
-----END PGP SIGNATURE-----

--Sig_/MJAAzOcNE.bvnm./NZ5_ffa--
