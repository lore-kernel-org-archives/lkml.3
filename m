Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3HGPx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:53:57 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:59699 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3HGPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:53:55 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v3 1/5] sata, highbank: fix ordering of SGPIO signals
Date: Wed,  7 Aug 2013 10:52:34 -0500
Message-Id: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACTIVITY and ERROR signals were reversed in the original commit.
Fix that so that hard drive activity does not show up on the error
light, and attempts to indicate that the hard drive is failing do
not show up as hard drive activity. This fixes a fairly serious
functional bug in the driver, but failing to apply this patch will
not cause any stability issues on the system.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v2
	Further rewords of the commit message.
Changes from v1
        Expanded commit message explaining the problems with the
unpatched code.

 drivers/ata/sata_highbank.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index d047d92..e9a4f46 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -86,11 +86,11 @@ struct ecx_plat_data {
 
 #define SGPIO_SIGNALS			3
 #define ECX_ACTIVITY_BITS		0x300000
-#define ECX_ACTIVITY_SHIFT		2
+#define ECX_ACTIVITY_SHIFT		0
 #define ECX_LOCATE_BITS			0x80000
 #define ECX_LOCATE_SHIFT		1
 #define ECX_FAULT_BITS			0x400000
-#define ECX_FAULT_SHIFT			0
+#define ECX_FAULT_SHIFT			2
 static inline int sgpio_bit_shift(struct ecx_plat_data *pdata, u32 port,
 				u32 shift)
 {
-- 
1.8.1.2

