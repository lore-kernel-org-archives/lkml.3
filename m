Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3CLIwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:52:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3CLIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:52:05 -0400
Date: Tue, 12 Mar 2013 01:50:35 -0700
From: tip-bot for Zhang Yanfei <tipbot@zytor.com>
Message-ID: <tip-ad0304cfd90f46bfcae3a6cd2b69067741541730@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        tglx@linutronix.de
In-Reply-To: <513EB5DA.2010300@cn.fujitsu.com>
References: <513EB5DA.2010300@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/intel/mrst:
  Remove cast for kmalloc() return value
Git-Commit-ID: ad0304cfd90f46bfcae3a6cd2b69067741541730
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Mar 2013 01:50:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad0304cfd90f46bfcae3a6cd2b69067741541730
Gitweb:     http://git.kernel.org/tip/ad0304cfd90f46bfcae3a6cd2b69067741541730
Author:     Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
AuthorDate: Tue, 12 Mar 2013 12:58:02 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Mar 2013 09:10:20 +0100

x86/platform/intel/mrst: Remove cast for kmalloc() return value

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/513EB5DA.2010300@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/mrst/mrst.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e31bcd8..a0a0a43 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -356,8 +356,7 @@ static int __init sfi_parse_gpio(struct sfi_table_header *table)
 	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
 	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
 
-	gpio_table = (struct sfi_gpio_table_entry *)
-				kmalloc(num * sizeof(*pentry), GFP_KERNEL);
+	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
 	if (!gpio_table)
 		return -1;
 	memcpy(gpio_table, pentry, num * sizeof(*pentry));
