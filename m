Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3JVWcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:32:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3JVWbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:20 -0400
Message-ID: <5266FCB5.8080904@infradead.org>
Date: Tue, 22 Oct 2013 15:31:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH resend] platform/x86: fix asus-wmi build error
References: <523749AB.7010805@infradead.org>
In-Reply-To: <523749AB.7010805@infradead.org>
X-Forwarded-Message-Id: <523749AB.7010805@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Randy Dunlap <rdunlap@infradead.org>

Fix build error in asus_wmi.c when ASUS_WMI=y and ACPI_VIDEO=m
by preventing that combination.

drivers/built-in.o: In function `asus_wmi_probe':
asus-wmi.c:(.text+0x65ddb4): undefined reference to `acpi_video_unregister'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Found in linux-next but applies to mainline.

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20130916.orig/drivers/platform/x86/Kconfig
+++ linux-next-20130916/drivers/platform/x86/Kconfig
@@ -504,6 +504,7 @@ config ASUS_WMI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
 	depends on HOTPLUG_PCI
+	depends on ACPI_VIDEO || ACPI_VIDEO = n
 	select INPUT_SPARSEKMAP
 	select LEDS_CLASS
 	select NEW_LEDS



