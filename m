Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3LBUlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:41:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3LBTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Guinot <simon.guinot@sequanux.org>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Michael Turquette <mturquette@deferred.io>
Subject: [PATCH 3.10 125/173] clk: armada-370: fix tclk frequencies
Date: Mon,  2 Dec 2013 11:11:48 -0800
Message-Id: <20131202191157.914236748@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/mvebu/clk-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/mvebu/clk-core.c
+++ b/drivers/clk/mvebu/clk-core.c
@@ -126,8 +126,8 @@ static void __init mvebu_clk_core_setup(
 #define	    SARH_AXP_FAB_FREQ_OPT_SHIFT	    4
 
 static const u32 __initconst armada_370_tclk_frequencies[] = {
-	16600000,
-	20000000,
+	166000000,
+	200000000,
 };
 
 static u32 __init armada_370_get_tclk_freq(void __iomem *sar)


