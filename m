Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaEXG07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 02:26:59 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55935 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaEXG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 02:26:58 -0400
Message-ID: <1400912816.31526.73.camel@x220>
Subject: [PATCH] pcmcia: m32r: remove check for CONFIG_M32RPCC_SLOT2
From: Paul Bolle <pebolle@tiscali.nl>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-pcmcia@lists.infradead.org, linux-m32r@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 08:26:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2014 06:26:56.0867 (UTC) FILETIME=[2959C330:01CF7719]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver contains a check for CONFIG_M32RPCC_SLOT2 ever since it was
added in v2.6.10 it. But there's no matching Kconfig symbol. Remove
that check. But leave the second call of add_pcc_socket() if-zeroed out.
The code clearly is written to be able handle two sockets. It's just not
clear if it is always safe to do that. Add a comment to clarify this
decision.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Pet peeve: the code has module support, but M32R_PCC is bool!

 drivers/pcmcia/m32r_pcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index 296514155cd5..a86ada82b61c 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -695,7 +695,7 @@ static int __init init_m32r_pcc(void)
 
 	add_pcc_socket(M32R_PCC0_BASE, PCC0_IRQ, M32R_PCC0_MAPBASE, 0x1000);
 
-#ifdef CONFIG_M32RPCC_SLOT2
+#if 0 /* XXX In what cases is it OK to do this? */
 	add_pcc_socket(M32R_PCC1_BASE, PCC1_IRQ, M32R_PCC1_MAPBASE, 0x2000);
 #endif
 
-- 
1.9.0

