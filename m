Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbbAVUza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:55:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbbAVUz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:55:27 -0500
Date: Thu, 22 Jan 2015 12:55:05 -0800
From: tip-bot for Juergen Gross <tipbot@zytor.com>
Message-ID: <tip-31bb7723706ba9660504a6c3903ea46198f98fd1@git.kernel.org>
Cc: steven@uplinklabs.net, linux-kernel@vger.kernel.org, toshi.kani@hp.com,
        jgross@suse.com, hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org
Reply-To: steven@uplinklabs.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, jgross@suse.com,
        hpa@zytor.com, mingo@kernel.org
In-Reply-To: <1421926997-28615-1-git-send-email-jgross@suse.com>
References: <1421926997-28615-1-git-send-email-jgross@suse.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm: Change cachemode exports to non-gpl
Git-Commit-ID: 31bb7723706ba9660504a6c3903ea46198f98fd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31bb7723706ba9660504a6c3903ea46198f98fd1
Gitweb:     http://git.kernel.org/tip/31bb7723706ba9660504a6c3903ea46198f98fd1
Author:     Juergen Gross <jgross@suse.com>
AuthorDate: Thu, 22 Jan 2015 12:43:17 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 21:50:14 +0100

x86, mm: Change cachemode exports to non-gpl

Commit 281d4078bec3 ("x86: Make page cache mode a real type")
introduced the symbols __cachemode2pte_tbl and __pte2cachemode_tbl and
exported them via EXPORT_SYMBOL_GPL.  The exports are part of a
replacement of code which has been EXPORT_SYMBOL before these changes
resulting in build breakage of out-of-tree non-gpl modules.

Change EXPORT_SYMBOL_GPL to EXPORT-SYMBOL for these two symbols.

Fixes: 281d4078bec3 "x86: Make page cache mode a real type"
Reported-and-tested-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Link: http://lkml.kernel.org/r/1421926997-28615-1-git-send-email-jgross@suse.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 08a7d31..079c3b6 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -43,7 +43,7 @@ uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
 	[_PAGE_CACHE_MODE_WT]		= _PAGE_PCD,
 	[_PAGE_CACHE_MODE_WP]		= _PAGE_PCD,
 };
-EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
+EXPORT_SYMBOL(__cachemode2pte_tbl);
 uint8_t __pte2cachemode_tbl[8] = {
 	[__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
 	[__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
@@ -54,7 +54,7 @@ uint8_t __pte2cachemode_tbl[8] = {
 	[__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
 	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
 };
-EXPORT_SYMBOL_GPL(__pte2cachemode_tbl);
+EXPORT_SYMBOL(__pte2cachemode_tbl);
 
 static unsigned long __initdata pgt_buf_start;
 static unsigned long __initdata pgt_buf_end;
