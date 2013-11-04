Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3KDGEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:04:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40092 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3KDGEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:04:24 -0500
Date: Mon, 4 Nov 2013 17:04:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next: manual merge of the random tree with Linus' tree
Message-Id: <20131104170411.ccd38895fb4cdc347f9cf912@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Nov_2013_17_04_11_+1100_44nvzJDM0uRvqkvQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Nov_2013_17_04_11_+1100_44nvzJDM0uRvqkvQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next merge of the random tree got a conflict in
drivers/base/core.c between commit 63967685605b ("driver core: add
#include <linux/sysfs.h> to core files") from Linus' tree and commit
f0ed2b943a53 ("random: use device attach events for entropy") from the
random tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/core.c
index 67b180d855b2,5e98fc379d0f..000000000000
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@@ -26,7 -26,7 +26,8 @@@
  #include <linux/async.h>
  #include <linux/pm_runtime.h>
  #include <linux/netdevice.h>
 +#include <linux/sysfs.h>
+ #include <linux/random.h>
 =20
  #include "base.h"
  #include "power/power.h"

--Signature=_Mon__4_Nov_2013_17_04_11_+1100_44nvzJDM0uRvqkvQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSdzjgAAoJEMDTa8Ir7ZwVYBEP+wdrwsJB/cxc+6QPXJqsNA8i
uR76QmydEI1yMGUeOFp15CJmmBniPw0K/28OthiD1aW1x6zih8tguYpJquO1vfK/
TMB76Jpk4Ml1uKe5gBcMcCi4B2I5RXDnJ2vnC/Enq78/NmQ8GqA526+baNExzunr
CW04bgjeoC6R9Eg498VJfZUDq2HaK08exiv5RJgCd0roUNKBuQ5SSBAPS+l8nTVE
YXKMyd2brWmhA6Db0oR3v+xcDoKLKb4kUmI2NkwXOPZaRuz/F/+ErrZzXLS02+31
g8IGRptZ0Q3ZmqsqfGHW4rkj675yc5tpFE9DFGRDY9kFLwrNQbmmUBndhVNpZw4I
8fdUgQlXlAdhHrLlipmUrPt3ZM/cd2k8udWutlUZ4w1KWOdVnHmwdFrES2YZk2gF
mH0VWgIvoIYYrwz6sO08X6+EU0sEz7uZbYVb31ZZo7nvHXwQPDUwdeXht4ZblJNM
QIdg1PRo/DE10XH3PYBD1zVuDxeWVA2GLVtDBYyCK+nCtZZ4bPcSOdbnYdSsedLO
XHT82dEaZZWgisV9xchoQhjCES0mdOtgK3n0yhKxpSVIQGkea0ZGBIl8kKfuHBA3
C3pnUe1ocNTOaZOZhQmzAztH5J08RGzV97eDJm5Hd8rWLWBDOFG6MJsfq8fCUIC1
HO9rzJNxtWITU3JCUcfS
=FSNm
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Nov_2013_17_04_11_+1100_44nvzJDM0uRvqkvQ--
