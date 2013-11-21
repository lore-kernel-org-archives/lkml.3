Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab3KUFNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:13:33 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55947 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3KUFNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:13:31 -0500
Date: Wed, 20 Nov 2013 21:13:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Denis Carikli <denis@eukrea.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: tsc2007 - remove unused poll_delay from platform data
Message-ID: <20131121051319.GA6131@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

****
Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT (KEYBOARD,...,commit_signer:7/7=100%,commit_signer:2/2=100%)
Bill Pemberton <wfp5p@virginia.edu> (commit_signer:3/7=43%)
Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:2/7=29%)
Javier Martinez Canillas <javier@dowhile0.org> (commit_signer:1/7=14%)
Russell King <rmk+kernel@arm.linux.org.uk> (commit_signer:1/7=14%)
linux-input@vger.kernel.org (open list:INPUT (KEYBOARD,...)
linux-kernel@vger.kernel.org (open list)
****
Authors
drivers/input/touchscreen/tsc2007.c: Kwangwoo Lee <kwangwoo.lee@gmail.com>
include/linux/i2c/tsc2007.h: Kwangwoo Lee <kwangwoo.lee@gmail.com>
****
The driver does not use poll_delay parameter, so let's remove it.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/tsc2007.c | 2 --
 include/linux/i2c/tsc2007.h         | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 390148c..48a165a 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -75,7 +75,6 @@ struct tsc2007 {
 	u16			model;
 	u16			x_plate_ohms;
 	u16			max_rt;
-	unsigned long		poll_delay;
 	unsigned long		poll_period;
 	int			fuzzx;
 	int			fuzzy;
@@ -352,7 +351,6 @@ static int tsc2007_probe_pdev(struct i2c_client *client, struct tsc2007 *ts,
 	ts->model             = pdata->model;
 	ts->x_plate_ohms      = pdata->x_plate_ohms;
 	ts->max_rt            = pdata->max_rt ? : MAX_12BIT;
-	ts->poll_delay        = pdata->poll_delay ? : 1;
 	ts->poll_period       = pdata->poll_period ? : 1;
 	ts->get_pendown_state = pdata->get_pendown_state;
 	ts->clear_penirq      = pdata->clear_penirq;
diff --git a/include/linux/i2c/tsc2007.h b/include/linux/i2c/tsc2007.h
index 041c8e8..4f35b6a 100644
--- a/include/linux/i2c/tsc2007.h
+++ b/include/linux/i2c/tsc2007.h
@@ -7,8 +7,6 @@ struct tsc2007_platform_data {
 	u16	model;				/* 2007. */
 	u16	x_plate_ohms;	/* must be non-zero value */
 	u16	max_rt; /* max. resistance above which samples are ignored */
-	unsigned long poll_delay; /* delay (in ms) after pen-down event
-				     before polling starts */
 	unsigned long poll_period; /* time (in ms) between samples */
 	int	fuzzx; /* fuzz factor for X, Y and pressure axes */
 	int	fuzzy;
-- 
1.8.3.1


-- 
Dmitry
