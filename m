Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaKSBod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 20:44:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37666 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaKSBoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 20:44:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Vrabel <david.vrabel@citrix.com>, Wang Nan <wangnan0@huawei.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/3] x86: Fix typo in mark_rodata_ro
Date: Tue, 18 Nov 2014 17:44:14 -0800
Message-Id: <1416361456-11060-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the comment, should use cleanup_highmap().
and also remove not needed cast for _brk_end, as it is
unsigned long.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -1145,9 +1145,9 @@ void mark_rodata_ro(void)
 	 * of the PMD will remain mapped executable.
 	 *
 	 * Any PMD which was setup after the one which covers _brk_end
-	 * has been zapped already via cleanup_highmem().
+	 * has been zapped already via cleanup_highmap().
 	 */
-	all_end = roundup((unsigned long)_brk_end, PMD_SIZE);
+	all_end = roundup(_brk_end, PMD_SIZE);
 	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
