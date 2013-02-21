Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3BUSkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:40:33 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:63914 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3BUSk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:40:27 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, Marc Gauthier <marc@tensilica.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-xtensa@linux-xtensa.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] xtensa: Flat DeviceTree copy not future-safe
Date: Fri, 22 Feb 2013 00:09:22 +0530
Message-ID: <1361471962-25164-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flat DT copy code calls bootmem allocator with @align = 0.
This is probably OK with legacy allocator which xtensa uses right now,
but this will panic right away with memblock allocator

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Marc Gauthier <marc@tensilica.com>
Cc: linux-xtensa@linux-xtensa.org
Cc: linux-kernel@vger.kernel.org
---
 arch/xtensa/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 6dd25ec..c2a526e 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -256,7 +256,7 @@ void __init early_init_devtree(void *params)
 static void __init copy_devtree(void)
 {
 	void *alloc = early_init_dt_alloc_memory_arch(
-			be32_to_cpu(initial_boot_params->totalsize), 0);
+			be32_to_cpu(initial_boot_params->totalsize), 8);
 	if (alloc) {
 		memcpy(alloc, initial_boot_params,
 				be32_to_cpu(initial_boot_params->totalsize));
-- 
1.7.4.1

