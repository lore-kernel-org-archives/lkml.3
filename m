Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3LSL0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:26:44 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47963 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LSLZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:25:19 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=5D=20drivers=3A=20base=3A=20Add=20prototype=20declaration=20to=20the=20header=20file?=
Date: Thu, 19 Dec 2013 16:54:57 +0530
Message-Id: <1387452297-28836-1-git-send-email-rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131218063953.GA3180@rashika>
References: <20131218063953.GA3180@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function memory_block_size_bytes() to
the header file include/linux/memory.h.

This eliminates the following warning in memory.c:
drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

Changes since v1:
Incorrect Fix

 include/linux/memory.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/memory.h b/include/linux/memory.h
index 9a6bbf7..8c8f51c 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -35,6 +35,7 @@ struct memory_block {
 };
 
 int arch_get_memory_phys_device(unsigned long start_pfn);
+unsigned long __weak memory_block_size_bytes(void);	
 
 /* These states are exposed to userspace as text strings in sysfs */
 #define	MEM_ONLINE		(1<<0) /* exposed to userspace */
-- 
1.7.9.5

