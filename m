Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaGLLg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:36:57 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:30364 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbaGLLgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8KALscwVNXQ56W/2dsb2JhbABZgw6tMQEBAQEBAQUBbgGcAAGBDRd1hAQBBVYjEFE5HhmIRgG0Q5InF4V7iVAHFoQtBZsOlB2DRjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 6/7]  powerpc/cell: replace sscanf by kstrtouint
Date: Sat, 12 Jul 2014 13:36:19 +0200
Message-Id: <1405164980-9525-7-git-send-email-fabf@skynet.be>
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
 arch/powerpc/platforms/cell/cbe_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/cbe_thermal.c b/arch/powerpc/platforms/cell/cbe_thermal.c
index 2c15ff0..d71c3c4 100644
--- a/arch/powerpc/platforms/cell/cbe_thermal.c
+++ b/arch/powerpc/platforms/cell/cbe_thermal.c
@@ -129,9 +129,9 @@ static ssize_t store_throttle(struct cbe_pmd_regs __iomem *pmd_regs, const char
 	u64 new_value;
 	int ret;
 
-	ret = sscanf(buf, "%u", &temp);
+	ret = kstrtouint(buf, 0, &temp);
 
-	if (ret != 1 || temp < TEMP_MIN || temp > TEMP_MAX)
+	if (ret || temp < TEMP_MIN || temp > TEMP_MAX)
 		return -EINVAL;
 
 	new_value = temp_to_reg(temp);
-- 
1.9.1

