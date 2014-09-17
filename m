Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaIQHWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:22:25 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:64734 "EHLO
	relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaIQHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:22:23 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v5 2/3] usb: Rename usb-common.c
Date: Wed, 17 Sep 2014 09:21:12 +0200
Message-Id: <1410938473-29385-3-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410938473-29385-1-git-send-email-sojka@merica.cz>
References: <1410938473-29385-1-git-send-email-sojka@merica.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: s8H7LeQW032352
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.151, required 6, autolearn=not spam, BAYES_00 -0.50,
	HEADER_FROM_DIFFERENT_DOMAINS 0.00, RP_MATCHES_RCVD -0.65)
X-FELK-MailScanner-From: sojkam1@fel.cvut.cz
X-FELK-MailScanner-Watermark: 1411543303.27561@GApKo6Hvg9HUq14VFVGl1Q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the next commit, we will want the usb-common module to be composed of
two object files. Since Kbuild cannot "append" another object to an
existing one, we need to rename usb-common.c to something
else (common.c) and create usb-common.o by linking the wanted objects
together. Currently, usb-common.o comprises only common.o.

Signed-off-by: Michal Sojka <sojka@merica.cz>
---
 drivers/usb/common/Makefile                   | 4 +++-
 drivers/usb/common/{usb-common.c => common.c} | 0
 2 files changed, 3 insertions(+), 1 deletion(-)
 rename drivers/usb/common/{usb-common.c => common.c} (100%)

diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
index 7526461..052c120 100644
--- a/drivers/usb/common/Makefile
+++ b/drivers/usb/common/Makefile
@@ -2,5 +2,7 @@
 # Makefile for the usb common parts.
 #
 
-obj-$(CONFIG_USB_COMMON) += usb-common.o
+obj-$(CONFIG_USB_COMMON)	  += usb-common.o
+usb-common-y			  += common.o
+
 obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
diff --git a/drivers/usb/common/usb-common.c b/drivers/usb/common/common.c
similarity index 100%
rename from drivers/usb/common/usb-common.c
rename to drivers/usb/common/common.c
-- 
2.1.0

