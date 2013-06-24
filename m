Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3FXP40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:56:26 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50172 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3FXP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:56:25 -0400
From: Max Filippov <jcmvbkbc@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: Marc Gauthier <marc@tensilica.com>, linux-xtensa@linux-xtensa.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] xtensa: Flat DeviceTree copy not future-safe
Date: Mon, 24 Jun 2013 19:55:59 +0400
Message-Id: <1372089360-10079-6-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1372089360-10079-1-git-send-email-jcmvbkbc@gmail.com>
References: <1372089360-10079-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>

flat DT copy code calls bootmem allocator with @align = 0.
This is probably OK with legacy allocator which xtensa uses right now,
but this will panic right away with memblock allocator

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Marc Gauthier <marc@tensilica.com>
Cc: linux-xtensa@linux-xtensa.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 14c6c3a..42a8bba 100644
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
1.7.7.6

