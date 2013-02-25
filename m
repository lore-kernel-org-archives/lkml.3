Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab3BYBRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 20:17:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37431 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab3BYBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 20:17:44 -0500
Date: Mon, 25 Feb 2013 12:17:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the watchdog tree with Linus' tree
Message-Id: <20130225121732.29aad0f57349a5dce64ffd47@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Feb_2013_12_17_32_+1100_7QGgLUEoyJ/0XADm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2013_12_17_32_+1100_7QGgLUEoyJ/0XADm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/rtc/rtc-stmp3xxx.c between commit c8a6046e1e0b ("drivers/rtc: use
of_match_ptr() macro") from Linus' tree and commit e02f5cf6b648 ("rtc:
stmp3xxx: add wdt-accessor function") from the watchdog tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rtc/rtc-stmp3xxx.c
index b2a8ed9,cc9a9b6..0000000
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@@ -26,7 -26,8 +26,9 @@@
  #include <linux/rtc.h>
  #include <linux/slab.h>
  #include <linux/of_device.h>
 +#include <linux/of.h>
+ #include <linux/stmp_device.h>
+ #include <linux/stmp3xxx_rtc_wdt.h>
 =20
  #include <mach/common.h>
 =20

--Signature=_Mon__25_Feb_2013_12_17_32_+1100_7QGgLUEoyJ/0XADm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRKrusAAoJEECxmPOUX5FE7sEP+wTXTefo4R1H/AiGyA0SwmAh
BQENwVo9Aph3YqQn4PFvHL1HSNufXcCXOQ/pOr4wAnBW5XlelQRKsLrC3Tcz/4BJ
w5bvdYCdJ7jyvfgZBrCeITX46A2Mg1Xi6jQ5tgpU6RzpXLWcRHzgzFBr02CpnBxU
fIzODr1CaiuSEb+vDKFWl/YvwVlTwmBwWHG3GjiwFfIJZY0mKIertoNFESdkQkjR
BVF8QNdmXqyKkw17SLEkV1nGadX+6eINwV8SJ6tAHpQFWWhE0SoABBH/p5UrNlYG
Vt9g+TC6vBf93CdFLeCFsrZ2kPZ2uFsY2ePLlRrWWaw0cFwKPoQlB1EHOCB8Zngn
A1UBzOYBNncXMCvXJOhmrFsjTZp1PfflOwTVAZaLS8/4fRhRiFLzvlJJyi1NMfVV
tG3yOe1yOiK4PlPs27MEc181x+547J45TpDIq+fMtel0ZbISbOCTzOuvG2stIcum
nWuJpy5a0rNtP6pdsXpjttYKggdo0/E0lR1kucWRCI52DX2F4xMGQrgAP2JLh72g
2BdLLpLQ/eql0/I2nM9wQGZ7x8f3EyGmpU8SVjhwuaD3lL/PeVTIc8WDQLtiPMB6
mtyoXbFFh5XJRA0N+ZPaNEmyt9JZqyVd/TAaTokMHhU6RzG6RIVB5u8IKrfWDqnN
AoaJvc05lqh35E8qvvz6
=OMXI
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2013_12_17_32_+1100_7QGgLUEoyJ/0XADm--
