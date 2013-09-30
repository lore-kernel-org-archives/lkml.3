Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3I3NT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:19:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12616 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3I3NTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:19:51 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-aa-52497a76f293
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] TTY: bfin_jtag_comm: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 15:19:36 +0200
Message-id: <1440912.o8ggj5i0bG@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAd2yKs8gg7uHVS2aF69ns/j8exer
	xdmmN+wWl3fNYXNg8dg/dw27R9+WVYweZxYcYff4vEkugCWKyyYlNSezLLVI3y6BK+PE/aVs
	BavYK5bfncXUwDidrYuRg0NCwETi6qKKLkZOIFNM4sK99UBhLg4hgUWMEm+WfmOEcFqYJBoW
	nWMEqWITsJKY2L4KzBYRMJboPzuLHcRmFsiSWLyglxnEFhbwl2j9+IMJxGYRUJWYPnsWmM0r
	oCkx/fxmsHpRAU+JT5OWMkPEBSV+TL7HAjFHXmLf/qmsELaWxPqdx5kmMPLNQlI2C0nZLCRl
	CxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB+Mz6R2MqxosDjEKcDAq8fBaLPUIEmJN
	LCuuzD3EKMHBrCTCK17mGSTEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampB
	ahFMlomDU6qBcf721pta25/eEE3xkj4WvsWyJqBddpWcepfPB5uFWepvg577ucyZbiO/6FAH
	381fe2ROX5zQcY735s9iBb9idt5rpm7i54xXvGlMe+1eF8Y2gz88cjWvY7y3yLQIg8oGLVPV
	9YIN3Jzn7kp8L6y/eYJJNtTGc3bBxPz753XiBef9UwuYoLReiaU4I9FQi7moOBEAgvLTzUIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__initdata tag should be placed between the variable name and equal
sign for the variable to be placed in the intended .init.data section.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/tty/bfin_jtag_comm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index a93a424..8096fcb 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -349,7 +349,7 @@ bfin_jc_early_write(struct console *co, const char *buf, unsigned int count)
 	bfin_jc_straight_buffer_write(buf, count);
 }
 
-static struct __initdata console bfin_jc_early_console = {
+static struct console bfin_jc_early_console __initdata = {
 	.name   = "early_BFJC",
 	.write   = bfin_jc_early_write,
 	.flags   = CON_ANYTIME | CON_PRINTBUFFER,
-- 
1.8.2.3


