Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaCHBG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:06:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaCHBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:06:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vinayak Kale <vkale@apm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.4 05/99] ARM: 7957/1: add DSB after icache flush in __flush_icache_all()
Date: Fri,  7 Mar 2014 17:07:01 -0800
Message-Id: <20140308010611.785120364@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinayak Kale <vkale@apm.com>

commit 39544ac9df20f73e49fc6b9ac19ff533388c82c0 upstream.

Add DSB after icache flush to complete the cache maintenance operation.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/cacheflush.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -202,6 +202,7 @@ extern void copy_to_user_page(struct vm_
 static inline void __flush_icache_all(void)
 {
 	__flush_icache_preferred();
+	dsb();
 }
 
 #define flush_cache_all()		__cpuc_flush_kern_all()


