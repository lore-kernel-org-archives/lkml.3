Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaDOMV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:21:57 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62935 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOMVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:21:55 -0400
X-Google-Original-From: Vincent Donnefort <vincent.donnefort@seagate.com>
From: Vincent Donnefort <vdonnefort@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ptyser@xes-inc.com, linus.walleij@linaro.org, eparis@redhat.com,
        gnurou@gmail.com, linux-gpio@vger.kernel.org,
        Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH] gpio: ich: set regs and reglen for i3100 and ich6 chipset
Date: Tue, 15 Apr 2014 14:21:43 +0200
Message-Id: <1397564503-5175-1-git-send-email-vincent.donnefort@seagate.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140415084056.GA26578@ks3318809.kimsufi.com>
References: <20140415084056.GA26578@ks3318809.kimsufi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Donnefort <vdonnefort@gmail.com>

This patch fixes kernel NULL pointer BUG introduced by the following commit:
b667cf488aa9476b0ab64acd91f2a96f188cfd21
gpio: ich: Add support for multiple register addresses.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index e73c675..7030422 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -305,6 +305,8 @@ static struct ichx_desc ich6_desc = {
 
 	.ngpio = 50,
 	.have_blink = true,
+	.regs = ichx_regs,
+	.reglen = ichx_reglen,
 };
 
 /* Intel 3100 */
@@ -324,6 +326,8 @@ static struct ichx_desc i3100_desc = {
 	.uses_gpe0 = true,
 
 	.ngpio = 50,
+	.regs = ichx_regs,
+	.reglen = ichx_reglen,
 };
 
 /* ICH7 and ICH8-based */
-- 
1.8.3.2

