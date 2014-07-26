Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaGZWZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 18:25:36 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47559 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaGZWZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 18:25:35 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Fei Yang <fei.yang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: platform: intel-mid: sfi.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 00:26:58 +0200
Message-Id: <1406413618-7691-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are going to use memset before strncpy you must copy sizeof -1

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/platform/intel-mid/sfi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 994c40b..97e79c9 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -359,7 +359,7 @@ static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
 	void *pdata = NULL;
 
 	memset(&spi_info, 0, sizeof(spi_info));
-	strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
+	strncpy(spi_info.modalias, pentry->name, sizeof(spi_info.modalias) - 1);
 	spi_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
 	spi_info.bus_num = pentry->host_num;
 	spi_info.chip_select = pentry->addr;
@@ -389,7 +389,7 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 	void *pdata = NULL;
 
 	memset(&i2c_info, 0, sizeof(i2c_info));
-	strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
+	strncpy(i2c_info.type, pentry->name, sizeof(i2c_info.type) - 1);
 	i2c_info.irq = ((pentry->irq == (u8)0xff) ? 0 : pentry->irq);
 	i2c_info.addr = pentry->addr;
 	pr_debug("I2C bus = %d, name = %16.16s, irq = 0x%2x, addr = 0x%x\n",
-- 
1.7.10.4

