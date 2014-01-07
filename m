Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaAGLzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:55:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaAGLzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:55:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>, linux-usb@vger.kernel.org
Subject: ohci-at91 mismerge build error
Date: Tue, 07 Jan 2014 12:54:58 +0100
Message-ID: <20240208.HaoioSGuhF@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5gyD5VqWX7GKXjNBf2Ca+0q1+J1zov7yniBZwFKOo8P
 QcwN20SdVEPIc1XIercPLN/NJ0qOytmr8JzVYhthGGkhUeNL1b
 bjVpxuy7iQ2Kf5rm8WBXwzydn/QXdM2gZihR0UF7Rtzz809X32
 vw38vDFvfsTHM9LMEAKL5qoe2X52tywmG9wUNuc+sRaqgJS7qu
 OB662s5C5V3t8sbBLZs4mtSth/V4D79Fi+QVzoduCeKRouUuuy
 Ox5vj8CPRHn6RpSWaFS5dY8bg3SSEZZy71IbzXquxnnlXxZn9U
 VSR4UqCjx0VRk8SfpjBVIEmmAmZ3xJutg0N+laCbKQQhDoPQPb
 sEEwUuZSBLyNZnAmcoLA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 99f14bd4d1 "Merge 3.13-rc5 into usb-next" (in linux-next as of
today), I'm getting this error building any at91 kernel:

drivers/usb/host/ohci-at91.c: In function 'usb_hcd_at91_probe':
drivers/usb/host/ohci-at91.c:190:4: error: label 'err' used but not defined
    goto err;
    ^
drivers/usb/host/ohci-at91.c: At top level:
drivers/usb/host/ohci-at91.c:206:2: warning: data definition has no type or storage class [enabled by default]
  at91_stop_hc(pdev);
  ^
...

The problem is obviously a mismerge between two unrelated changes that
resulted in missing opening braces.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please just ignore if this has been reported before

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 2d0ee5e..091ae49 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -197,7 +197,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	at91_start_hc(pdev);
 
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (retval == 0)
+	if (retval == 0) {
 		device_wakeup_enable(hcd->self.controller);
 		return retval;
 	}

