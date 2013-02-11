Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3BKTqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:46:38 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50395 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759687Ab3BKTpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:45:09 -0500
Message-Id: <20130211194508.457937455@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-15.17.1
Date: Mon, 11 Feb 2013 13:45:10 -0600
From: Mike Travis <travis@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/7] x86/UV/UV3: Update ACPI Check to include SGI UV3
References: <20130211194508.033167376@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=uv3-update-acpi-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add UV3 to exclusion list.  Instead of adding every new series of
SGI UV systems, just check oem_id to have a prefix of "SGI".

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/mmconfig-shared.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux.orig/arch/x86/pci/mmconfig-shared.c
+++ linux/arch/x86/pci/mmconfig-shared.c
@@ -548,8 +548,7 @@ static int __init acpi_mcfg_check_entry(
 	if (cfg->address < 0xFFFFFFFF)
 		return 0;
 
-	if (!strcmp(mcfg->header.oem_id, "SGI") ||
-			!strcmp(mcfg->header.oem_id, "SGI2"))
+	if (!strncmp(mcfg->header.oem_id, "SGI", 3))
 		return 0;
 
 	if (mcfg->header.revision >= 1) {

