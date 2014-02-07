Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaBGMf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:35:29 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47953 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaBGMfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:35:24 -0500
Date: Fri, 7 Feb 2014 18:05:19 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 13/26] drivers: isdn: Mark functions as static in avmfritz.c
Message-ID: <3215b0668fa427737d7850d6ee9e7c67075983d5.1390408517.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in hardware/mISDN/avmfritz.c because they are
not used outside this file.

This eliminates the following warnings in hardware/mISDN/avmfritz.c:
drivers/isdn/hardware/mISDN/avmfritz.c:288:1: warning: no previous prototype for ‘write_ctrl’ [-Wmissing-prototypes]
drivers/isdn/hardware/mISDN/avmfritz.c:745:1: warning: no previous prototype for ‘clear_pending_hdlc_ints’ [-Wmissing-prototypes]
drivers/isdn/hardware/mISDN/avmfritz.c:966:1: warning: no previous prototype for ‘setup_fritz’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/mISDN/avmfritz.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/avmfritz.c b/drivers/isdn/hardware/mISDN/avmfritz.c
index 292991c..e3fa1cd 100644
--- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -284,7 +284,7 @@ __write_ctrl_pciv2(struct fritzcard *fc, struct hdlc_hw *hdlc, u32 channel) {
 					  AVM_HDLC_STATUS_1));
 }
 
-void
+static void
 write_ctrl(struct bchannel *bch, int which) {
 	struct fritzcard *fc = bch->hw;
 	struct hdlc_hw *hdlc;
@@ -741,7 +741,7 @@ inithdlc(struct fritzcard *fc)
 	modehdlc(&fc->bch[1], -1);
 }
 
-void
+static void
 clear_pending_hdlc_ints(struct fritzcard *fc)
 {
 	u32 val;
@@ -962,7 +962,7 @@ avm_dctrl(struct mISDNchannel *ch, u32 cmd, void *arg)
 	return err;
 }
 
-int
+static int
 setup_fritz(struct fritzcard *fc)
 {
 	u32 val, ver;
-- 
1.7.9.5

