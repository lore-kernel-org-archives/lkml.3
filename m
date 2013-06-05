Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab3FEVf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab3FEVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Abraham <abrahamh@web.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 030/127] Input: egalax_ts - ABS_MT_POSITION_Y not reported well
Date: Wed,  5 Jun 2013 14:33:17 -0700
Message-Id: <20130605213221.397742214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Abraham <abrahamh@web.de>

commit 3c9cfa782e075cc2348b949ba139911aac02c7cb upstream.

The egalax_ts touchscreen modul not report ABS_MT_POSITION_Y proper.
As result it may be, that upper software levels only receive x coordinates well.

Signed-off-by: Heiko Abraham <abrahamh@web.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/egalax_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -216,7 +216,7 @@ static int egalax_ts_probe(struct i2c_cl
 	input_set_abs_params(input_dev,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_X, 0, 0);
 	input_set_abs_params(input_dev,
-			     ABS_MT_POSITION_X, 0, EGALAX_MAX_Y, 0, 0);
+			     ABS_MT_POSITION_Y, 0, EGALAX_MAX_Y, 0, 0);
 	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS, 0);
 
 	input_set_drvdata(input_dev, ts);


