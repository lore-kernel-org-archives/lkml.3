Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3HBQ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:28:36 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:39222 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030Ab3HBQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:28:33 -0400
X-Greylist: delayed 3893 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Aug 2013 12:28:33 EDT
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v2 1/5] sata, highbank: fix ordering of SGPIO signals
Date: Fri,  2 Aug 2013 11:28:34 -0500
Message-Id: <1375460918-4661-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACTIVITY and ERROR signals were reversed in the original commit.
Fix that so that hard drive activity does not show up on the error
light, and attempts to indicate that the hard drive is failing do
not show up as hard drive activity. There is no other change to
the driver other than sending the signals to the LED PIC in the
correct order.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
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

