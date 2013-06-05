Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3FEPHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:07:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17935 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3FEPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:07:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 08:06:43 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] clk: honor CLK_GET_RATE_NOCACHE in clk_set_rate
Date: Wed, 5 Jun 2013 18:06:36 +0300
Message-ID: <1370444796-18648-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
References: <1370444796-18648-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_set_rate() uses clk->rate directly. This causes problems if the clock
is marked as CLK_GET_RATE_NOCACHE. Hence call clk_get_rate() to get the
current rate.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9b2f941..2e669a8 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1216,7 +1216,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_prepare_lock();
 
 	/* bail early if nothing to do */
-	if (rate == clk->rate)
+	if (rate == clk_get_rate(clk))
 		goto out;
 
 	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
-- 
1.7.7.rc0.72.g4b5ea.dirty

