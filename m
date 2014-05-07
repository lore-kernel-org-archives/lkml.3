Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaEGGW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:22:27 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51407 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaEGGWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:22:24 -0400
From: Toby Smith <toby@tismith.id.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Toby Smith <toby@tismith.id.au>
Subject: [PATCH 1/2] staging: lustre: fix sparse warning "should it be static"
Date: Wed,  7 May 2014 16:21:21 +1000
Message-Id: <fa60cf3b2659d5082eed14fa10743128ecbcf5d0.1399443599.git.toby@tismith.id.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1399443599.git.toby@tismith.id.au>
References: <cover.1399443599.git.toby@tismith.id.au>
In-Reply-To: <cover.1399443599.git.toby@tismith.id.au>
References: <cover.1399443599.git.toby@tismith.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning in lib-eq.c
warning: symbol 'lnet_eq_dequeue_event' was not declared. Should it be static?

Signed-off-by: Toby Smith <toby@tismith.id.au>
---
 drivers/staging/lustre/lnet/lnet/lib-eq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-eq.c b/drivers/staging/lustre/lnet/lnet/lib-eq.c
index 7ce07f6..6e63c23 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-eq.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-eq.c
@@ -238,7 +238,7 @@ lnet_eq_enqueue_event(lnet_eq_t *eq, lnet_event_t *ev)
 	lnet_eq_wait_unlock();
 }
 
-int
+static int
 lnet_eq_dequeue_event(lnet_eq_t *eq, lnet_event_t *ev)
 {
 	int		new_index = eq->eq_deq_seq & (eq->eq_size - 1);
-- 
1.9.1

