Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaIDKo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:44:56 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:65235 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbaIDKoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:44:55 -0400
Message-ID: <1409827493.5546.103.camel@x220>
Subject: [PATCH] [next-20140903] staging: emxx_udc: remove check for
 CONFIG_MACH_EMGR
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 04 Sep 2014 12:44:53 +0200
In-Reply-To: <1403252540.22857.20.camel@x220>
References: <20140606104408.4423.36098.sendpatchset@w520>
	 <20140606104417.4423.38999.sendpatchset@w520>
	 <1403252540.22857.20.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 10:44:53.0511 (UTC) FILETIME=[42B27970:01CFC82D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a check for CONFIG_MACH_EMGR. But the Kconfig symbol MACH_EMGR
doesn't exist. Remove that check and the single #define it hides. Note
that this macro isn't used by this driver anyway.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only (on x86_64).

 drivers/staging/emxx_udc/emxx_udc.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.h b/drivers/staging/emxx_udc/emxx_udc.h
index 578fdcfed5e9..ee1b80d705fa 100644
--- a/drivers/staging/emxx_udc/emxx_udc.h
+++ b/drivers/staging/emxx_udc/emxx_udc.h
@@ -437,10 +437,6 @@
 #define PLL_RESUME			BIT05		/* RW */
 #define PLL_LOCK			BIT04		/* R */
 
-#ifdef CONFIG_MACH_EMGR
-#define PLL_RST				BIT02		/* RW */
-#endif
-
 #define EPC_RST				BIT00		/* RW */
 
 /*------- (0x1014) USBF_EPTEST Register */
-- 
1.9.3


