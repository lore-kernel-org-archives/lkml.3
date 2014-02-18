Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaBRW6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:58:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaBRWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vinayak Kale <vkale@apm.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.13 16/40] arm64: add DSB after icache flush in __flush_icache_all()
Date: Tue, 18 Feb 2014 14:47:17 -0800
Message-Id: <20140218224433.794602875@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinayak Kale <vkale@apm.com>

commit 5044bad43ee573d0b6d90e3ccb7a40c2c7d25eb4 upstream.

Add DSB after icache flush to complete the cache maintenance operation.
The function __flush_icache_all() is used only for user space mappings
and an ISB is not required because of an exception return before executing
user instructions. An exception return would behave like an ISB.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/cacheflush.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -116,6 +116,7 @@ extern void flush_dcache_page(struct pag
 static inline void __flush_icache_all(void)
 {
 	asm("ic	ialluis");
+	dsb();
 }
 
 #define flush_dcache_mmap_lock(mapping) \


