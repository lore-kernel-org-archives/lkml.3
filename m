Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3IKE5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3IKE4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:49 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1mCEvTPW4_oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ft1gyNbaDVYA:10 a=gOGYGX67AAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=wMNdZWldAAAA:8 a=k9hV8fVBw1oq-BZ04IkA:9 a=UhhopG4jCfkA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042932.924220274@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eugene Surovegin <surovegin@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [242/251] powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0242-powerpc-hvsi-Increase-handshake-timeout-from-200ms-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eugene Surovegin <ebs@ebshome.net>

[ Upstream commit d220980b701d838560a70de691b53be007e99e78 ]

This solves a problem observed in kexec'ed kernel where 200ms timeout is
too short and bootconsole fails to initialize. Console did eventually
become workable but much later into the boot process.

Observed timeout was around 260ms, but I decided to make it a little bigger
for more reliability.

This has been tested on Power7 machine with Petitboot as a primary
bootloader and PowerNV firmware.

CC: <stable@vger.kernel.org>
Signed-off-by: Eugene Surovegin <surovegin@google.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/tty/hvc/hvsi_lib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 59c135d..2c51419 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -341,8 +341,8 @@ void hvsilib_establish(struct hvsi_priv *pv)
 
 	pr_devel("HVSI@%x:   ... waiting handshake\n", pv->termno);
 
-	/* Try for up to 200s */
-	for (timeout = 0; timeout < 20; timeout++) {
+	/* Try for up to 400ms */
+	for (timeout = 0; timeout < 40; timeout++) {
 		if (pv->established)
 			goto established;
 		if (!hvsi_get_packet(pv))
-- 
1.7.10.4


