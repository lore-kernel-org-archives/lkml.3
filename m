Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaEGGWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:22:30 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36223 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaEGGW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:22:28 -0400
From: Toby Smith <toby@tismith.id.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Toby Smith <toby@tismith.id.au>
Subject: [PATCH 2/2] staging: lustre: fix sparse warning "unexpected unlock"
Date: Wed,  7 May 2014 16:21:22 +1000
Message-Id: <668d22755bddc8bd7f439019a74224f33d0cde14.1399443599.git.toby@tismith.id.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1399443599.git.toby@tismith.id.au>
References: <cover.1399443599.git.toby@tismith.id.au>
In-Reply-To: <cover.1399443599.git.toby@tismith.id.au>
References: <cover.1399443599.git.toby@tismith.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning in lib-eq.c
warning: context imbalance in 'lnet_eq_wait_locked' - unexpected unlock

Signed-off-by: Toby Smith <toby@tismith.id.au>
---
 drivers/staging/lustre/lnet/lnet/lib-eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-eq.c b/drivers/staging/lustre/lnet/lnet/lib-eq.c
index 6e63c23..d25dcd8 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-eq.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-eq.c
@@ -325,6 +325,7 @@ EXPORT_SYMBOL(LNetEQWait);
 
 static int
 lnet_eq_wait_locked(int *timeout_ms)
+__must_hold(&the_lnet.ln_eq_wait_lock)
 {
 	int		tms = *timeout_ms;
 	int		wait;
-- 
1.9.1

