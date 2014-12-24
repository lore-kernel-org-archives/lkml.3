Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaLXOni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 09:43:38 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:38158 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaLXOng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 09:43:36 -0500
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: mturquette@linaro.org, linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH] clk-gate: fix bit # check in clk_register_gate()
Date: Wed, 24 Dec 2014 17:43:27 +0300
Message-ID: <2500887.6mMDBajo0S@wasted.cogentembedded.com>
Organization: Cogent Embedded Inc.
User-Agent: KMail/4.14.3 (Linux/3.17.7-200.fc20.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case CLK_GATE_HIWORD_MASK flag is passed to clk_register_gate(), the bit #
should be no higher than 15, however the corresponding check is obviously off-
by-one.

Fixes: 045779942c04 ("clk: gate: add CLK_GATE_HIWORD_MASK")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
The patch is against Linus' repo because the 'clk-fixes' branch  in  Mike
Turquette's 'linux.git' repo at Linaro seems very outdated. BTW, the repo
at kernel.org specified by the MAINTAINERS file doesn't seem to exist --
can something be done about that?

 drivers/clk/clk-gate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/clk/clk-gate.c
===================================================================
--- linux.orig/drivers/clk/clk-gate.c
+++ linux/drivers/clk/clk-gate.c
@@ -128,7 +128,7 @@ struct clk *clk_register_gate(struct dev
 	struct clk_init_data init;
 
 	if (clk_gate_flags & CLK_GATE_HIWORD_MASK) {
-		if (bit_idx > 16) {
+		if (bit_idx > 15) {
 			pr_err("gate bit exceeds LOWORD field\n");
 			return ERR_PTR(-EINVAL);
 		}

