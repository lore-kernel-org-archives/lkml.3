Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3GJJqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:46:20 -0400
Received: from tx2outboundsmtppool2.messaging.microsoft.com ([65.55.83.132]:16479
	"EHLO TX2EHSNDR002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752059Ab3GJJqS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:46:18 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h15abkzz8275ch17326ah8275bh8275dhz2dh87h2a8h668h839h93fhd24he5bhf0ah1239h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b5bh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h41h42h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, <trivial@kernel.org>
Subject: [PATCH linux-next] ARM: imx: fix imx_init_l2cache storage class
Date: Wed, 10 Jul 2013 11:45:46 +0200
Message-ID: <1373449546-1040-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Reply-To: <vstehle@debian>
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 879ec1ceeac21285d62606c1e96520887efcd9bc makes imx_init_l2cache a common
function and updates the header declaration accordingly. Fix function storage
class, too.

This fixes the following compilation error:

  arch/arm/mach-imx/system.c:101:123: error: static declaration of ‘imx_init_l2cache’ follows non-static declaration
  In file included from arch/arm/mach-imx/system.c:32:0:
  arch/arm/mach-imx/common.h:165:13: note: previous declaration of ‘imx_init_l2cache’ was here
  arch/arm/mach-imx/system.c:101:123: warning: ‘imx_init_l2cache’ defined but not used [-Wunused-function]

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: trivial@kernel.org
---


Hi,

Linux next-20130710 breaks compilation of ARM multi_v7_defconfig. This patch fixes it.

(Note: this patch is necessary for the link, too: http://www.spinics.net/lists/kernel/msg1563777.html)

Best regards,

V.


 arch/arm/mach-imx/system.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/system.c b/arch/arm/mach-imx/system.c
index e5592ca..64ff37e 100644
--- a/arch/arm/mach-imx/system.c
+++ b/arch/arm/mach-imx/system.c
@@ -98,7 +98,7 @@ void __init mxc_arch_reset_init_dt(void)
 }
 
 #ifdef CONFIG_CACHE_L2X0
-static void __init imx_init_l2cache(void)
+void __init imx_init_l2cache(void)
 {
 	void __iomem *l2x0_base;
 	struct device_node *np;
-- 
1.7.10.4



