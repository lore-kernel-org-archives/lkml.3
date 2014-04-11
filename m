Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbaDKPrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:47:32 -0400
Received: from mail.abilis.ch ([195.70.19.74]:11835 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbaDKPr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:47:28 -0400
X-Greylist: delayed 3655 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 11:47:27 EDT
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devicetree@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] pinctrl/TB10x: Fix signedness bug
Date: Fri, 11 Apr 2014 16:46:04 +0200
Message-Id: <1397227564-8698-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20140402111358.GA23000@mwanda>
References: <20140402111358.GA23000@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the TB10x pin database, a port index of -1 is used to indicate
unmuxed GPIO pin groups. This bug fixes a 'cast to unsigned' bug of
this value.

Thanks to Dan Carpenter for highlighting this.

CC: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 drivers/pinctrl/pinctrl-tb10x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tb10x.c b/drivers/pinctrl/pinctrl-tb10x.c
index c5e0f69..26ca685 100644
--- a/drivers/pinctrl/pinctrl-tb10x.c
+++ b/drivers/pinctrl/pinctrl-tb10x.c
@@ -629,9 +629,8 @@ static int tb10x_gpio_request_enable(struct pinctrl_dev *pctl,
 	 */
 	for (i = 0; i < state->pinfuncgrpcnt; i++) {
 		const struct tb10x_pinfuncgrp *pfg = &state->pingroups[i];
-		unsigned int port = pfg->port;
 		unsigned int mode = pfg->mode;
-		int j;
+		int j, port = pfg->port;
 
 		/*
 		 * Skip pin groups which are always mapped and don't need
-- 
1.7.1

