Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3F0MnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:43:13 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:31473
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab3F0MnL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:43:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Robin Holt <holt@sgi.com>, Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <trivial@kernel.org>
Subject: [PATCH linux-next] arm: zynq: fix compilation warning
Date: Thu, 27 Jun 2013 14:42:41 +0200
Message-ID: <1372336962-6459-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compilation warning:

  arch/arm/mach-zynq/common.c:110:2: warning: initialization from incompatible pointer type [enabled by default]
  arch/arm/mach-zynq/common.c:110:2: warning: (near initialization for ‘__mach_desc_XILINX_EP107.restart’) [enabled by default]

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: trivial@kernel.org
---


Hi,

This warning was seen on linux-next tag next-20130627, with config ARM
multi_v7_defconfig.

Best regards,

V.


 arch/arm/mach-zynq/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 4130e65..8ea5f11 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -91,7 +91,7 @@ static void __init zynq_map_io(void)
 	zynq_scu_map_io();
 }
 
-static void zynq_system_reset(char mode, const char *cmd)
+static void zynq_system_reset(enum reboot_mode mode, const char *cmd)
 {
 	zynq_slcr_system_reset();
 }
-- 
1.7.10.4



