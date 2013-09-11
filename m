Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3IKE7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3IKE5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:06 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=rpzfmIMlpfcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=R-5X08-UIR8A:10 a=tmtSDGaQAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=JTMqrY5UvyEA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042923.452640978@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>
Subject: [188/251] nsp32: use mdelay instead of large udelay constants
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0188-nsp32-use-mdelay-instead-of-large-udelay-constants.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b497ceb964a80ebada3b9b3cea4261409039e25a ]

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/nsp32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 62b6168..e705ed3 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2926,7 +2926,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME / 1000);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
-- 
1.7.10.4


