Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3CYJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:27:16 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:63750 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758121Ab3CYJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:27:14 -0400
Message-ID: <1364203632.1390.254.camel@x61.thuisdomein>
Subject: [PATCH] staging: lirc: remove dead code
From: Paul Bolle <pebolle@tiscali.nl>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 10:27:12 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 09:27:12.0542 (UTC) FILETIME=[EE6F0BE0:01CE293A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lirc uses the CONFIG_SA1100_BITSY Kconfig macro. But its Kconfig symbol
was removed in v2.4.13. So we can remove a few lines of dead code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, but of rather low risk. Note that support for the
machine_is_bitsy() macro was already removed in v2.4.10. 

 drivers/staging/media/lirc/lirc_sir.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 63a554c..f781c53 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -787,12 +787,6 @@ static int init_hardware(void)
 	spin_lock_irqsave(&hardware_lock, flags);
 	/* reset UART */
 #ifdef LIRC_ON_SA1100
-#ifdef CONFIG_SA1100_BITSY
-	if (machine_is_bitsy()) {
-		pr_info("Power on IR module\n");
-		set_bitsy_egpio(EGPIO_BITSY_IR_ON);
-	}
-#endif
 #ifdef CONFIG_SA1100_COLLIE
 	sa1100_irda_set_power_collie(3);	/* power on */
 #endif
@@ -942,10 +936,6 @@ static void drop_hardware(void)
 	Ser2UTCR3 = sr.utcr3;
 
 	Ser2HSCR0 = sr.hscr0;
-#ifdef CONFIG_SA1100_BITSY
-	if (machine_is_bitsy())
-		clr_bitsy_egpio(EGPIO_BITSY_IR_ON);
-#endif
 #ifdef CONFIG_SA1100_COLLIE
 	sa1100_irda_set_power_collie(0);	/* power off */
 #endif
-- 
1.7.11.7

