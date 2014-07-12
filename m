Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaGLLge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:36:34 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:27785 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbaGLLga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8KALscwVNXQ56W/2dsb2JhbABZgw6tMQEBAQEBAQUBbgGcAAGBDRd1hAQBBVYjEFE5HhmIRgG0Q5InF4V7iVAHFoQtBZsOlB2DRjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/7] powerpc: fadump: replace sscanf by kstrtoint
Date: Sat, 12 Jul 2014 13:36:14 +0200
Message-Id: <1405164980-9525-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405164980-9525-1-git-send-email-fabf@skynet.be>
References: <1405164980-9525-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See checkpatch warning
"Prefer kstrto<type> to single variable sscanf"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/powerpc/kernel/fadump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 742694c..3c40b5f 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -426,6 +426,7 @@ static inline int fadump_gpr_index(u64 id)
 {
 	int i = -1;
 	char str[3];
+	int rc;
 
 	if ((id & GPR_MASK) == REG_ID("GPR")) {
 		/* get the digits at the end */
@@ -434,8 +435,8 @@ static inline int fadump_gpr_index(u64 id)
 		str[2] = '\0';
 		str[1] = id & 0xff;
 		str[0] = (id >> 8) & 0xff;
-		sscanf(str, "%d", &i);
-		if (i > 31)
+		rc = kstrtoint(str, 0, &i);
+		if (rc || i > 31)
 			i = -1;
 	}
 	return i;
-- 
1.9.1

