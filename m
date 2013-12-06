Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161873Ab3LFNj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:39:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161644Ab3LFNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Guinot <simon.guinot@sequanux.org>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Michael Turquette <mturquette@deferred.io>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 151/272] clk: armada-370: fix tclk frequencies
Date: Fri,  6 Dec 2013 12:57:20 +0000
Message-Id: <1386334761-25517-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Guinot <simon.guinot@sequanux.org>

commit 1022c75f5abd3a3b25e679bc8793d21bedd009b4 upstream.

This patch fixes the tclk frequency array for the Armada-370 SoC.
This bug has been introduced by commit 6b72333d
("clk: mvebu: add Armada 370 SoC-centric clock init").

A wrong tclk frequency affects the following drivers: mvsdio, mvneta,
i2c-mv64xxx and mvebu-devbus. This list may be incomplete.

About the mvneta Ethernet driver, note that the tclk frequency is used
to compute the Rx time coalescence. Then, this bug harms the coalescence
configuration and also degrades the networking performances with the
default values.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Michael Turquette <mturquette@deferred.io>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/mvebu/armada-370.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mvebu/armada-370.c b/drivers/clk/mvebu/armada-370.c
index fc777bd..81a202d 100644
--- a/drivers/clk/mvebu/armada-370.c
+++ b/drivers/clk/mvebu/armada-370.c
@@ -39,8 +39,8 @@ static const struct coreclk_ratio a370_coreclk_ratios[] __initconst = {
 };
 
 static const u32 a370_tclk_freqs[] __initconst = {
-	16600000,
-	20000000,
+	166000000,
+	200000000,
 };
 
 static u32 __init a370_get_tclk_freq(void __iomem *sar)
-- 
1.8.3.2

