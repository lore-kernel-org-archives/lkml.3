Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3FTHKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:10:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57006 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3FTHKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:10:07 -0400
Date: Thu, 20 Jun 2013 17:09:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the tip tree
Message-Id: <20130620170951.248631b40c84c30a1a57ba7f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_17_09_51_+1000_78.Fb=v_Trqckf6N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_17_09_51_+1000_78.Fb=v_Trqckf6N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-integrator/integrator_ap.c between commit 38ff87f77af0
("sched_clock: Make ARM's sched_clock generic for all architectures")
from the tip tree and commit 01ef31053ddd ("ARM: integrator: move VGA
base assignment") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-integrator/integrator_ap.c
index aa43462,a5b15c4..0000000
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@@ -41,8 -41,6 +41,7 @@@
  #include <linux/stat.h>
  #include <linux/sys_soc.h>
  #include <linux/termios.h>
 +#include <linux/sched_clock.h>
- #include <video/vga.h>
 =20
  #include <mach/hardware.h>
  #include <mach/platform.h>

--Signature=_Thu__20_Jun_2013_17_09_51_+1000_78.Fb=v_Trqckf6N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwqrEAAoJEECxmPOUX5FE7ZcP/2aLQObFpIJj57rw7tPwlPLB
QItGpphI9kgtnT2geFpAQhU1yUR6WLVQpSkMp3+wGhvkOJlsyGNruH6tMT8JBfwI
XEvtjsqLZo/Z720ievpvas54QRHYpDtMCcG8W0WY59svQ1ahc7x9Z4Ky3VbM58LA
U5UqIX9rimtdcRRmvwFMf5+NGINwOGDAERVqdjf0mWoDI9P5Yhq3OfqNTlYxq3Z4
7FwG956IKOvJLbvaa3+Z0wVu0MNpW5aagkEm4EtfyA+lctSwMjitIGqmptM7qlbq
vF3Jairn1wnSdQXTPS3ubJIqVAqafdH4tqvhraY54DzDSVwS+0zzg9f6f8fNpK9K
pQXemX/Kyvnay2UdgYdflDPyDRLW7lTap2LBd31zv0+8KJGVoOB18LT+dfO8CypO
2YCFfk+MO5/VGUigan5yP/EF2hFZWm1yibsM0gtHUlNDc0dpXitSAAdKxDKMBatN
VGff7vonDZIY4LQ3L83/gTn9BjJmxTYUJOeAeGIOzWWfMOBsM+oWJ00eYwJWX2Oc
nY2gdOzPXdGjf0DWiiyoUqcuCTXOpa2o0db1KMqWV6FdxbiqmpFvvPLWQmdMPeBA
SDUMTIm1ql0bNcvmbgnn5ayiIVZ1rhpBvZ21KJVlfdZFS03o432T12IvVbrx61Rm
PKL55sENrMq7YETCkAqk
=3E2p
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_17_09_51_+1000_78.Fb=v_Trqckf6N--
