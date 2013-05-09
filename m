Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3EIKlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:41:13 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:53390 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3EIKlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:41:09 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 20/21] powerpc/ps3: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:58 +0400
Message-Id: <1368095819-11011-9-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 arch/powerpc/platforms/ps3/spu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/ps3/spu.c b/arch/powerpc/platforms/ps3/spu.c
index e17fa14..a0bca05 100644
--- a/arch/powerpc/platforms/ps3/spu.c
+++ b/arch/powerpc/platforms/ps3/spu.c
@@ -143,7 +143,7 @@ static void _dump_areas(unsigned int spe_id, unsigned long priv2,
 	pr_debug("%s:%d: shadow:  %lxh\n", func, line, shadow);
 }
 
-inline u64 ps3_get_spe_id(void *arg)
+u64 ps3_get_spe_id(void *arg)
 {
 	return spu_pdata(arg)->spe_id;
 }
-- 
1.8.1.4

