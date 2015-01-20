Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbbATVZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:25:20 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60186 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751649AbbATVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:25:18 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] clk: Export phase functions
Date: Tue, 20 Jan 2015 22:23:43 +0100
Message-Id: <1421789023-3128-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The phase setter and getter were not exported until now, which was causing
build breakages when callers were compiled as module. Export these two
functions.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index f4963b7d4e17..e188c26ce197 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1778,6 +1778,7 @@ out_unlock:
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(clk_set_phase);
 
 /**
  * clk_get_phase - return the phase shift of a clock signal
@@ -1800,6 +1801,7 @@ int clk_get_phase(struct clk *clk)
 out:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(clk_get_phase);
 
 /**
  * __clk_init - initialize the data structures in a struct clk
-- 
2.2.2

