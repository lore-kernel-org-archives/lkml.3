Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3F0Mtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:49:45 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:10244
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab3F0Mto convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:49:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Robin Holt <holt@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        <trivial@kernel.org>
Subject: [PATCH linux-next] ARM: keystone: fix compilation warning
Date: Thu, 27 Jun 2013 14:49:27 +0200
Message-ID: <1372337367-6708-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compilation warning:

  arch/arm/mach-keystone/keystone.c:74:2: warning: initialization from incompatible pointer type [enabled by default]
  arch/arm/mach-keystone/keystone.c:74:2: warning: (near initialization for ‘__mach_desc_KEYSTONE.restart’) [enabled by default]

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: trivial@kernel.org
---


Hi,

This warning was seen on linux-next tag next-20130627, with config ARM
multi_v7_defconfig.

Best regards,

V.


 arch/arm/mach-keystone/keystone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
index fe4d9ff..b661c5c 100644
--- a/arch/arm/mach-keystone/keystone.c
+++ b/arch/arm/mach-keystone/keystone.c
@@ -49,7 +49,7 @@ static const char *keystone_match[] __initconst = {
 	NULL,
 };
 
-void keystone_restart(char mode, const char *cmd)
+void keystone_restart(enum reboot_mode mode, const char *cmd)
 {
 	u32 val;
 
-- 
1.7.10.4



