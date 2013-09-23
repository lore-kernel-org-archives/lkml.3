Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3IWEEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:04:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41762 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IWEEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:04:15 -0400
Date: Mon, 23 Sep 2013 14:04:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the random tree with Linus' tree
Message-Id: <20130923140401.67e7bb4560620a561d4dfe6e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Sep_2013_14_04_01_+1000_4u81gCCd1BIAt8cd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Sep_2013_14_04_01_+1000_4u81gCCd1BIAt8cd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Today's linux-next merge of the random tree got a conflict in init/main.c
between commit 65f382fd0c8f ("context_tracking: Ground setup for static
key use") from Linus' tree and commit 382521d2478b ("random: run
random_int_secret_init() run after all late_initcalls") from the random
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc init/main.c
index af310af,586cd33..0000000
--- a/init/main.c
+++ b/init/main.c
@@@ -75,7 -75,7 +75,8 @@@
  #include <linux/blkdev.h>
  #include <linux/elevator.h>
  #include <linux/sched_clock.h>
 +#include <linux/context_tracking.h>
+ #include <linux/random.h>
 =20
  #include <asm/io.h>
  #include <asm/bugs.h>

--Signature=_Mon__23_Sep_2013_14_04_01_+1000_4u81gCCd1BIAt8cd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSP722AAoJEECxmPOUX5FEMQkQAJ1cYJYtrjEOu/67vCUYp2eq
OlEiVPEhZu6fpP/X9bymZrdsW3pwHQU82zgoTRaE2WBsNarIQcNoqjpCN/5rL6XW
M0RuQYnq1K+kkM1E+A78285hhFbx/gTAkvDxjEKnXtrN/jD7Kt1IM7pObAbgjBnH
Rpcr/oTaPdchxVrUgSDAGyO5M+ja+L+3e/MGfzyLiDLIpAtET+STvfI+fEpamp62
QveY6dXaq4CRqHSsWfvOv89Uz9lAJvK1P1OFYey8GLStnACPZmorBS6IZttEE9WC
GIEUGnssOo62UQN27+6ljDb5LUA9Sfg8jEQIYZ2X+M+e7XCa2bfqfvQpCJrcwKbZ
aFdIgJJ+660w2+us5JBAB8CvmTEedrghiyZmBtUWTInpg/McMoJWO9L+kgtezzie
9FzcpDIh0st+Q6/7DnSMvSm9gfWaWBBbLXuQ5TGGMZuSmaJLi0uI3cjzNyeqktgK
81+rLNV4K3p7XmzKMoyREc/TWcn6RDA5VC/vHaRgvrjsntvynuAiEhvcGpv22f+Z
owovIedXSF5CThI+A8txOmBLX2YNoc70YNzWbq/VXRIF7o0+oi3TA668BDtzxFXp
IMxdGkJautCj8xSKULIblSLqfcHR/2B3TqI8XHTSQSpzYkbuQxdYeTJ35tjyqVk6
wCsCp0P6DwoeVU2zQpw2
=htev
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Sep_2013_14_04_01_+1000_4u81gCCd1BIAt8cd--
