Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3AXP3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:29:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3AXP32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:29:28 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XoxfLckjI24A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5eGq-DNswfoA:10 a=ecbOGpaYbWTLnq1u_A8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359041366.21576.146.camel@gandalf.local.home>
Subject: [PATCH] regulators/db8500: Fix compile failure for
 drivers/regulator/dbx500-prcmu.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <rmk@arm.linux.org.uk>
Date: Thu, 24 Jan 2013 10:29:26 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building for the snowball board, I ran into this compile failure:

  CC      drivers/regulator/dbx500-prcmu.o
arm-test.git/drivers/regulator/dbx500-prcmu.c:119:11: error: 'THIS_MODULE' undeclared here (not in a function)
make[3]: *** [drivers/regulator/dbx500-prcmu.o] Error 1
make[2]: *** [drivers/regulator] Error 2

Commit 38e968380 "regulators/db8500: split off shared dbx500 code"
separated out the dbx500 code but did not copy over the required include
to linux/module.h.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index 261f3d2..89bd2fa 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "dbx500-prcmu.h"
 


