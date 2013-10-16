Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab3JPLhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:37:39 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41930 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974Ab3JPLhi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 16 Oct 2013 07:37:38 -0400
Message-Id: <525E969E02000078000FB710@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 12:37:34 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: honor ACPI FADT flag indicating absence of a CMOS
 RTC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't be creating a corresponding platform device in that case.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/rtc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- 3.12-rc5/arch/x86/kernel/rtc.c
+++ 3.12-rc5-x86-ACPI-no-RTC/arch/x86/kernel/rtc.c
@@ -192,6 +192,11 @@ static __init int add_rtc_cmos(void)
 	if (mrst_identify_cpu())
 		return -ENODEV;
 
+#ifdef CONFIG_ACPI
+	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_CMOS_RTC)
+		return -ENODEV;
+#endif
+
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");



