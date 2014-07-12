Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaGLLhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:37:04 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:27785 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbaGLLgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8KALscwVNXQ56W/2dsb2JhbABZgw6tMQEBAQEBAQUBbgGcAAGBDRd1hAQBBVYjEFE5HhmIRgG0Q5InF4V7iVAHFoQtBZsOlB2DRjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/7] powerpc/powernv: replace sscanf %lx by kstrtoul 16
Date: Sat, 12 Jul 2014 13:36:16 +0200
Message-Id: <1405164980-9525-4-git-send-email-fabf@skynet.be>
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
 arch/powerpc/platforms/powernv/subcore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/subcore.c b/arch/powerpc/platforms/powernv/subcore.c
index 894ecb3..79721b2 100644
--- a/arch/powerpc/platforms/powernv/subcore.c
+++ b/arch/powerpc/platforms/powernv/subcore.c
@@ -337,9 +337,9 @@ static ssize_t __used store_subcores_per_core(struct device *dev,
 
 	/* We are serialised by the attribute lock */
 
-	rc = sscanf(buf, "%lx", &val);
-	if (rc != 1)
-		return -EINVAL;
+	rc = kstrtoul(buf, 16, &val);
+	if (rc)
+		return rc;
 
 	switch (val) {
 	case 1:
-- 
1.9.1

