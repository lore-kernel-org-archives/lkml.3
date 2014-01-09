Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaAIFuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 00:50:00 -0500
Received: from ozlabs.org ([203.10.76.45]:48553 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbaAIFt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 00:49:57 -0500
Date: Thu, 9 Jan 2014 16:49:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>, Bryan Wu <cooloney@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        achin Kamat <sachin.kamat@linaro.org>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: linux-next: manual merge of the gpio tree with the leds tree
Message-Id: <20140109164948.6a7341cfbd92258bc8d522e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Jan_2014_16_49_48_+1100_c0bIg7tr2/yIDwYC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jan_2014_16_49_48_+1100_c0bIg7tr2/yIDwYC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
drivers/leds/leds-s3c24xx.c between commit cfc7937fb6bd ("leds: s3c24xx:
Remove hardware.h inclusion") from the leds tree and commit 224feb33a645
("leds: s3c24xx: Fix build failure") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/leds/leds-s3c24xx.c
index b7876eb09e8c,87cf215af798..000000000000
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@@ -18,9 -18,11 +18,10 @@@
  #include <linux/gpio.h>
  #include <linux/slab.h>
  #include <linux/module.h>
 +#include <linux/platform_data/leds-s3c24xx.h>
 =20
 -#include <mach/hardware.h>
  #include <mach/regs-gpio.h>
+ #include <plat/gpio-cfg.h>
 -#include <linux/platform_data/leds-s3c24xx.h>
 =20
  /* our context */
 =20

--Signature=_Thu__9_Jan_2014_16_49_48_+1100_c0bIg7tr2/yIDwYC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzjiAAAoJEMDTa8Ir7ZwVlZUP/Rsb34h5Pow/hL8AA3uWw1p/
dRHeKJrfYvENm+C7+ZyNUrZZplBu/HSb8EqR1jsi/kLEVbduOPkVBHGo9VE1uKvY
L8rniETeVk+JKe/7qGlZps0dKDRy/CyqFzWyW4wd+OLv9jK45EbkzzpbxOOKS5z5
AiLJaDnbBPj6izALL2QPbTqM+28bpAL6v7gxUNNtwUzu/f8unwy3+AATEHD6UnkC
W6LkpGN2LWgCHzmoYTReiBUw8vs/K/vh5/Z+Ca4ci6MnPYrRo9K3dxT1YyUv42hc
/q2V8ntSgUbqxmXMLIA/VMTff1dXOb/NzvS90rkVv5iix6DBPXWCCmHEF3jE3J3T
XfA+Zg49kIXqelH8vO2s7JJt1zmy9eQZ3vRmkWlJrrJcCSIKav66qT8E17+s/Fuf
5bxubsw+7RBgTyMkTFLtXqu+wL/ZQbtMEtQ22TGPjciSkencv+kZ+fNl/iYSmr8d
P06OcwmS2DHYaWnCOPCslGWmJblBwaupro80Bv3iWfqra5Z+yPIfiJ5eykQORYiX
ZjQCTcD8oSa0hKZd4P10SXqygviUYRk02+8auK10bmdGFYsbGm2quZ/GxU1Nre/q
cqDZGjUhw8XRYuKLEp6KW1mMViuolzEII6k6XzmDEOHjNCoubxJ23dCR1MuBO2b6
QUV7MvcH1wr6xGZeGb6S
=2zkM
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jan_2014_16_49_48_+1100_c0bIg7tr2/yIDwYC--
