Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3CJUle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 16:41:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54146 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3CJUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 16:41:33 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] arch: x86: platform: uv: Replaced kmalloc & memset with kzalloc
Date: Sat,  9 Mar 2013 11:40:43 +0200
Message-Id: <1362822043-15559-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced kmalloc followed by memset calls with a single kzalloc call.
This was found using coccicheck.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 arch/x86/platform/uv/uv_time.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 98718f6..5c86786 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -159,10 +159,9 @@ static __init int uv_rtc_allocate_timers(void)
 {
 	int cpu;
 
-	blade_info = kmalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
+	blade_info = kzalloc(uv_possible_blades * sizeof(void *), GFP_KERNEL);
 	if (!blade_info)
 		return -ENOMEM;
-	memset(blade_info, 0, uv_possible_blades * sizeof(void *));
 
 	for_each_present_cpu(cpu) {
 		int nid = cpu_to_node(cpu);
-- 
1.7.9.5

