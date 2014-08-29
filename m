Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaH2NIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:08:34 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:58759 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbaH2NIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:08:30 -0400
From: Michal Sojka <sojka@merica.cz>
To: linux-usb@vger.kernel.org
Cc: Michal Sojka <sojka@merica.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-kernel@vger.kernel.org, michal.vokac@comap.cz
Subject: [PATCH v5 2/3] usb: Rename usb-common.c
Date: Fri, 29 Aug 2014 15:07:42 +0200
Message-Id: <1409317663-31160-3-git-send-email-sojka@merica.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409317663-31160-1-git-send-email-sojka@merica.cz>
References: <87k35rihcc.fsf@steelpick.2x.cz>
 <1409317663-31160-1-git-send-email-sojka@merica.cz>
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

