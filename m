Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3HVOJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:09:49 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:38115 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3HVOJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:09:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 10:09:38 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=zx2c4.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references; q=dns; s=mail; b=
	DWAS0IqIFJC44IAIFSRuCsohUiWHbcst/mQijs7AgtkpyPbbd4S3LAHI15I2evCK
	w/POOKk6NswuwnbeuqQFit9yFhmAVrL5dONTUTO3krOWeEjbaQ9YjVx7vMRip0ok
	UNnW6yLhVgiHjzS/dPhz4YQ64BbhxHVxXEWXFLzN/DI=
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, rjw@sisk.pl, len.brown@intel.com, dtor@insightbb.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 3/3] thinkpad_acpi: Wire unused micmute LED to capslock
Date: Thu, 22 Aug 2013 16:02:12 +0200
Message-Id: <1377180132-4933-3-git-send-email-Jason@zx2c4.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
References: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thinkpads with a micmute LED do not have a capslock LED. The micmute LED
is currently not used by any piece of Linux kernel land or user land. It
seems reasonable to hook it up to caps lock, at least by default, so
users can have some degree of functionality.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 33b23cb..708fdb8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5235,6 +5235,10 @@ static int __init tpacpi_init_led(unsigned int led)
 
 	tpacpi_leds[led].led_classdev.name = tpacpi_led_names[led];
 
+	/* Special case wiring micmute to caps-lock by default. */
+	if (led == 14)
+		tpacpi_leds[led].led_classdev.default_trigger = "caps-lock";
+
 	INIT_WORK(&tpacpi_leds[led].work, led_set_status_worker);
 
 	rc = led_classdev_register(&tpacpi_pdev->dev,
-- 
1.8.3.2

