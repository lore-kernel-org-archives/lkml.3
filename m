Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3CPBDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 21:03:34 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:29561 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab3CPBDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 21:03:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1363395775!10010705!14
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] backlight: ep93xx_bl: fix section mismatch
Date: Fri, 15 Mar 2013 18:03:08 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, Ryan Mallon <rmallon@gmail.com>,
        <rpurdie@rpsys.net>, <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201303151803.08774.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the __init tag from ep93xxbl_probe() to fix the section
mismatch warning.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/backlight/ep93xx_bl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index ef3e21e..17b8abb 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -60,7 +60,7 @@ static const struct backlight_ops ep93xxbl_ops = {
 	.get_brightness	= ep93xxbl_get_brightness,
 };
 
-static int __init ep93xxbl_probe(struct platform_device *dev)
+static int ep93xxbl_probe(struct platform_device *dev)
 {
 	struct ep93xxbl *ep93xxbl;
 	struct backlight_device *bl;
@@ -145,7 +145,6 @@ static struct platform_driver ep93xxbl_driver = {
 	.suspend	= ep93xxbl_suspend,
 	.resume		= ep93xxbl_resume,
 };
-
 module_platform_driver(ep93xxbl_driver);
 
 MODULE_DESCRIPTION("EP93xx Backlight Driver");
-- 
1.8.1.4

