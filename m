Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3BANIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:08:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:44450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab3BANI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:08:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 09/89] ARM: at91: rm9200: remake the BGA as default version
Date: Fri,  1 Feb 2013 14:07:24 +0100
Message-Id: <20130201130208.138243840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit 36224d0fe0f34cdde66a381708853ebadeac799c upstream.

Make BGA as the default version as we are supposed to just have
to specify when we use the PQFP version.

Issue was existing since commit:
3e90772 (ARM: at91: fix at91rm9200 soc subtype handling).

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/setup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -104,6 +104,8 @@ static void __init soc_detect(u32 dbgu_b
 	switch (socid) {
 	case ARCH_ID_AT91RM9200:
 		at91_soc_initdata.type = AT91_SOC_RM9200;
+		if (at91_soc_initdata.subtype == AT91_SOC_SUBTYPE_NONE)
+			at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
 		at91_boot_soc = at91rm9200_soc;
 		break;
 


