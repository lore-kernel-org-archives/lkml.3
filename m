Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab3LBVQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:16:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3LBTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roel Kluin <roel.kluin@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.10 023/173] pinctrl: dove: unset twsi option3 for gconfig as well
Date: Mon,  2 Dec 2013 11:10:06 -0800
Message-Id: <20131202191145.481174356@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit 6d0a4ed2b90a12e1403d3e7d9d8c2cc7fdc301b5 upstream.

This fixes a typo which left twsi config3 option enabled.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/mvebu/pinctrl-dove.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -323,7 +323,7 @@ static int dove_twsi_ctrl_set(struct mve
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
 	gcfg1 &= ~DOVE_TWSI_ENABLE_OPTION1;
-	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION2);
+	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION3);
 
 	switch (config) {
 	case 1:


