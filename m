Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966163Ab3E2NKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:10:23 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58339 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945Ab3E2NKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:10:21 -0400
Message-ID: <51A5FE2D.9080403@synopsys.com>
Date: Wed, 29 May 2013 18:40:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH 2/2] xtensa: Flat DeviceTree copy not future-safe
References: <1361471962-25164-3-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1361471962-25164-3-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.5.1
X-Forwarded-Message-Id: <1361471962-25164-3-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

This patch - acked by you then, got lost in the mist of time. Care to take it in
via xtensa tree for 3.11

Thx,
-Vineet


-------- Original Message --------
Subject: [PATCH 2/2] xtensa: Flat DeviceTree copy not future-safe
Date: Fri, 22 Feb 2013 00:09:22 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
Max Filippov <jcmvbkbc@gmail.com>, Marc Gauthier <marc@tensilica.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, <linux-xtensa@linux-xtensa.org>,
<linux-kernel@vger.kernel.org>
Newsgroups: gmane.linux.kernel
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>

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



