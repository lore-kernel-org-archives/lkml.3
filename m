Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3EaE7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 00:59:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46101 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3EaE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 00:59:24 -0400
Date: Fri, 31 May 2013 14:59:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: linux-next: build failure after merge of the final tree (msm tree
 related)
Message-Id: <20130531145915.e13b029dca07a2db098fb405@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__31_May_2013_14_59_15_+1000_WjpazMnSAZAi2bIH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__31_May_2013_14_59_15_+1000_WjpazMnSAZAi2bIH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpio/gpio-msm-v2.c: In function 'msm_gpio_irq_domain_map':
drivers/gpio/gpio-msm-v2.c:373:2: error: implicit declaration of function '=
set_irq_flags' [-Werror=3Dimplicit-function-declaration]
  set_irq_flags(irq, IRQF_VALID);
  ^
drivers/gpio/gpio-msm-v2.c:373:21: error: 'IRQF_VALID' undeclared (first us=
e in this function)
  set_irq_flags(irq, IRQF_VALID);
                     ^
drivers/gpio/gpio-msm-v2.c:373:21: note: each undeclared identifier is repo=
rted only once for each function it appears in
drivers/gpio/gpio-msm-v2.c: In function 'msm_gpio_remove':
drivers/gpio/gpio-msm-v2.c:450:18: error: 'TLMM_SCSS_SUMMARY_IRQ' undeclare=
d (first use in this function)
  irq_set_handler(TLMM_SCSS_SUMMARY_IRQ, NULL);
                  ^

Caused by commit 69cf52b46b39 ("gpio: msm: Add device tree and irqdomain
support for gpio-msm-v2").

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 31 May 2013 14:54:00 +1000
Subject: [PATCH] restore dependency on ARCH_MSM to GPIO_MSM_V2

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 2e4a21a..f471fe8 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -165,7 +165,7 @@ config GPIO_MSM_V1
=20
 config GPIO_MSM_V2
 	tristate "Qualcomm MSM GPIO v2"
-	depends on GPIOLIB && OF
+	depends on GPIOLIB && OF && ARCH_MSM
 	help
 	  Say yes here to support the GPIO interface on ARM v7 based
 	  Qualcomm MSM chips.  Most of the pins on the MSM can be
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__31_May_2013_14_59_15_+1000_WjpazMnSAZAi2bIH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRqC4nAAoJEECxmPOUX5FEwe8P/2aAztF7C5GkSPIJNtazhoT5
h5yv/nz6peFTfTZxXnRtdVTUovXiv3eDEP+pg2rDrOQFmTSfvnxseK9Zv9dy3STh
npUbKGLMgh5aRG9V2DsmUc/L1UtY9svbyryNLscoQXjK8vwueA95YXpooOpKjnqw
PmCxlPWLrx0Ba/oeDm4SaVjxirIBFQVdGjOyG3TUVco8NkKEWmpU6rCs3KuUjGx6
ahpDfGNUDfx4tkiHuKXs2RzENAWANd0NiUvA8VuKQC+68kT08WV7KrNZlXLuSqqy
D1rJWeDRxOjBRmUX/V2G0b2UrT2vno3ICVvTftbKu7j89Gme1mGElMcmxKqsv+AE
US39R0vuwlVT2dYH/2kV1UkUwdvNSMp73BTNaKFrFWCvCdTkVzSce7BY7BxyG+Iw
w0jeRBD72qGZ+U8s1IxXvF52WH16mm2bY78e2NlMTNY7qiLnpfcGYqvfqRR9dOFM
TLN02FdDOij3joDObd3VdL2qy7MurnLrPbL1ZFmYkvWBzo/PL8scR9dsZ6mR1nFj
32XbrlERNEed8PjT2w6xoxvhiA365NdJ9r0OuJ8sk8JqBSuH8fkKniIKZ4s1Xwnn
/EgzIlUT7JQu288/WuDuKT9KDVsdvxV7vurf1UrgXY7GTX2MFlgZEdgAWqzdGsts
SArjtLPD5C5fmUXlAbgp
=GlmU
-----END PGP SIGNATURE-----

--Signature=_Fri__31_May_2013_14_59_15_+1000_WjpazMnSAZAi2bIH--
