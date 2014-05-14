Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaENJ7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:59:53 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:61427 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbaENJ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:59:49 -0400
Message-ID: <1400061587.31197.18.camel@x220>
Subject: [PATCH] ARM: nommu: remove unused KTHREAD_SIZE #define
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 11:59:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2014 09:59:47.0762 (UTC) FILETIME=[3D443120:01CF6F5B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) A very similar commit is 10b5aabddd1e ("[PATCH]
include/asm-h8300/page.h: remove unused KTHREAD_SIZE #define"). I found
that commit by looking into the history of the unloved
CONFIG_SMALL_TASKS macro. References to it were added to (a few places
in) the tree, starting with v2.5.46. But I haven't found evidence that
it was ever defined.

 arch/arm/include/asm/page-nommu.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index d1b162a18dcb..58da8b22cf10 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -11,12 +11,6 @@
 #ifndef _ASMARM_PAGE_NOMMU_H
 #define _ASMARM_PAGE_NOMMU_H
 
-#if !defined(CONFIG_SMALL_TASKS) && PAGE_SHIFT < 13
-#define KTHREAD_SIZE (8192)
-#else
-#define KTHREAD_SIZE PAGE_SIZE
-#endif
- 
 #define get_user_page(vaddr)		__get_free_page(GFP_KERNEL)
 #define free_user_page(page, addr)	free_page(addr)
 
-- 
1.9.0

