Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaEVQ4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:56:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48868 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbaEVQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:48:16 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH v2 03/18] s390: io: remove dummy relaxed accessor macros for reads
Date: Thu, 22 May 2014 17:47:15 +0100
Message-Id: <1400777250-17335-4-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now defined by asm-generic/io.h, so we don't need the private
definitions anymore.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/s390/include/asm/io.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index cd6b9ee7b69c..722befdf8332 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -60,11 +60,6 @@ static inline void iounmap(volatile void __iomem *addr)
 #define __raw_writel	zpci_write_u32
 #define __raw_writeq	zpci_write_u64
 
-#define readb_relaxed	readb
-#define readw_relaxed	readw
-#define readl_relaxed	readl
-#define readq_relaxed	readq
-
 #endif /* CONFIG_PCI */
 
 #include <asm-generic/io.h>
-- 
1.9.2

