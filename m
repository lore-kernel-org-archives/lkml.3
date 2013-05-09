Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3EIKkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:40:31 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40891 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3EIKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:40:29 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Mikael Starvik <starvik@axis.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 17/21] CRISv32: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:55 +0400
Message-Id: <1368095819-11011-6-git-send-email-yefremov.denis@gmail.com>
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
 arch/cris/arch-v32/kernel/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/arch-v32/kernel/cache.c b/arch/cris/arch-v32/kernel/cache.c
index f38433b..876be53 100644
--- a/arch/cris/arch-v32/kernel/cache.c
+++ b/arch/cris/arch-v32/kernel/cache.c
@@ -5,7 +5,7 @@
 
 /* This file is used to workaround a cache bug, Guinness TR 106. */
 
-inline void flush_dma_descr(struct dma_descr_data *descr, int flush_buf)
+void flush_dma_descr(struct dma_descr_data *descr, int flush_buf)
 {
 	/* Flush descriptor to make sure we get correct in_eop and after. */
 	asm volatile ("ftagd [%0]" :: "r" (descr));
-- 
1.8.1.4

