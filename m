Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab3GCS6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:58:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab3GCSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:49 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=DHUcWIoQiNMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vdEnyU6BGJoA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=5KVauyKsRKMA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184046.948232931@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Heiko Abraham <abrahamh@web.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [014/141] Input: egalax_ts - ABS_MT_POSITION_Y not reported well
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0014-Input-egalax_ts-ABS_MT_POSITION_Y-not-reported-well.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Heiko Abraham <abrahamh@web.de>

[ Upstream commit 3c9cfa782e075cc2348b949ba139911aac02c7cb ]

The egalax_ts touchscreen modul not report ABS_MT_POSITION_Y proper.
As result it may be, that upper software levels only receive x coordinates well.

Signed-off-by: Heiko Abraham <abrahamh@web.de>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/input/touchscreen/egalax_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index 70524dd..be2a271 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -203,7 +203,7 @@ static int __devinit egalax_ts_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev,
 			     ABS_MT_POSITION_X, 0, EGALAX_MAX_X, 0, 0);
 	input_set_abs_params(input_dev,
-			     ABS_MT_POSITION_X, 0, EGALAX_MAX_Y, 0, 0);
+			     ABS_MT_POSITION_Y, 0, EGALAX_MAX_Y, 0, 0);
 	input_mt_init_slots(input_dev, MAX_SUPPORT_POINTS);
 
 	input_set_drvdata(input_dev, ts);
-- 
1.7.10.4


