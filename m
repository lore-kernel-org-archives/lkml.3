Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaGLLgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:36:54 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:27785 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbaGLLgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8KALscwVNXQ56W/2dsb2JhbABZgw6tMQEBAQEBAQUBbgGcAAGBDRd1hAQBBVYjEFE5HhmIRgG0Q5InF4V7iQJOBxaELQWbDpQdg0Y7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 7/7] powerpc/pseries: replace sscanf by kstrtoul
Date: Sat, 12 Jul 2014 13:36:20 +0200
Message-Id: <1405164980-9525-8-git-send-email-fabf@skynet.be>
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
 arch/powerpc/platforms/pseries/power.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/power.c b/arch/powerpc/platforms/pseries/power.c
index 6d62662..27a3e9c 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -38,11 +38,10 @@ static ssize_t auto_poweron_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t n)
 {
-	int ret;
 	unsigned long ups_restart;
-	ret = sscanf(buf, "%lu", &ups_restart);
+	int ret = kstrtoul(buf, 0, &ups_restart);
 
-	if ((ret == 1) && ((ups_restart == 1) || (ups_restart == 0))){
+	if ((!ret) && ((ups_restart == 1) || (ups_restart == 0))) {
 		rtas_poweron_auto = ups_restart;
 		return n;
 	}
-- 
1.9.1

