Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3EASox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:44:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:40372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab3EASob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:44:31 -0400
Message-ID: <51816271.3040400@infradead.org>
Date: Wed, 01 May 2013 11:44:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH -next] hid: fix hid-steelseries kconfig/build
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
In-Reply-To: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix hid-steelseries build by making it depends on LEDS_CLASS.
Build errors happen when LEDS_CLASS=m  and HID_STEELSERIES=y.

drivers/built-in.o: In function `steelseries_srws1_remove':
hid-steelseries.c:(.text+0x3b97a1): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `steelseries_srws1_probe':
hid-steelseries.c:(.text+0x3b9c51): undefined reference to `led_classdev_register'
hid-steelseries.c:(.text+0x3b9ce5): undefined reference to `led_classdev_register'
hid-steelseries.c:(.text+0x3b9d4b): undefined reference to `led_classdev_unregister'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20130501.orig/drivers/hid/Kconfig
+++ linux-next-20130501/drivers/hid/Kconfig
@@ -610,6 +610,7 @@ config HID_SPEEDLINK
 config HID_STEELSERIES
 	tristate "Steelseries SRW-S1 steering wheel support"
 	depends on HID
+	depends on LEDS_CLASS
 	---help---
 	Support for Steelseries SRW-S1 steering wheel
 
