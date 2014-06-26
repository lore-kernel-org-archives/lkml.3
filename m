Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaFZNWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:22:11 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6399 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaFZNWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:22:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jun 2014 06:15:58 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: define and export __clk_get_debug for providers
Date: Thu, 26 Jun 2014 16:22:01 +0300
Message-ID: <1403788921-7963-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and export a new function __clk_get_debug which returns the debugfs
directory entry pointer. This can be used by clock providers to add debugfs
entries which are not related to a specific clock type. Examples include the
ability to measure the rate of a clock. It can also be used by modules to
create new debugfs entries. This is useful if you want to expose features
for testing which can potentially cause system instability such as allowing
to change a clock's rate from userspace.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73ede..5fe7942 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -652,6 +652,15 @@ unsigned long __clk_get_flags(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(__clk_get_flags);
 
+struct dentry *__clk_get_dentry(struct clk *clk)
+{
+	if (!clk)
+		return NULL;
+
+	return clk->dentry;
+}
+EXPORT_SYMBOL_GPL(__clk_get_dentry);
+
 bool __clk_is_prepared(struct clk *clk)
 {
 	int ret;
-- 
1.7.7.rc0.72.g4b5ea.dirty

