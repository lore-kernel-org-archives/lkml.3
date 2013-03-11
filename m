Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3CKKDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:03:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3CKKDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:03:32 -0400
Date: Mon, 11 Mar 2013 03:02:17 -0700
From: tip-bot for Alexandru Gheorghiu <tipbot@zytor.com>
Message-ID: <tip-e87b686b5109e171438a0529828d3109b7ad6da3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gheorghiuandru@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gheorghiuandru@gmail.com, tglx@linutronix.de
In-Reply-To: <1362822043-15559-1-git-send-email-gheorghiuandru@gmail.com>
References: <1362822043-15559-1-git-send-email-gheorghiuandru@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/uv: Replace kmalloc()
  & memset with kzalloc()
Git-Commit-ID: e87b686b5109e171438a0529828d3109b7ad6da3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Mar 2013 03:02:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e87b686b5109e171438a0529828d3109b7ad6da3
Gitweb:     http://git.kernel.org/tip/e87b686b5109e171438a0529828d3109b7ad6da3
Author:     Alexandru Gheorghiu <gheorghiuandru@gmail.com>
AuthorDate: Sat, 9 Mar 2013 11:40:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 08:33:01 +0100

x86/platform/uv: Replace kmalloc() & memset with kzalloc()

This was found using coccicheck.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Link: http://lkml.kernel.org/r/1362822043-15559-1-git-send-email-gheorghiuandru@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_time.c | 3 +--
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
