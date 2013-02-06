Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab3BFW1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:27:14 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:48329 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775Ab3BFW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:27:12 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1360189605!12777089!39
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Organization: Vision Engraving Systems
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/11] pcmcia/ds.h: introduce helper for pcmcia_driver module boilerplate
Date: Wed, 6 Feb 2013 15:27:00 -0700
User-Agent: KMail/1.13.5 (Linux/3.7.0; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201302061527.00323.hsweeten@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the module_pcmcia_driver() macro which is a convenience macro
for pcmcia driver modules. It is intended to be used by pcmcia drivers
with init/exit sections that do nothing but register/unregister the
pcmcia driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 include/pcmcia/ds.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index 3bbbd78..2d56e42 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -65,6 +65,18 @@ struct pcmcia_driver {
 int pcmcia_register_driver(struct pcmcia_driver *driver);
 void pcmcia_unregister_driver(struct pcmcia_driver *driver);
 
+/**
+ * module_pcmcia_driver() - Helper macro for registering a pcmcia driver
+ * @__pcmcia_driver: pcmcia_driver struct
+ *
+ * Helper macro for pcmcia drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only use
+ * this macro once, and calling it replaces module_init() and module_exit().
+ */
+#define module_pcmcia_driver(__pcmcia_driver) \
+	module_driver(__pcmcia_driver, pcmcia_register_driver, \
+			pcmcia_unregister_driver)
+
 /* for struct resource * array embedded in struct pcmcia_device */
 enum {
 	PCMCIA_IOPORT_0,
-- 
1.8.1.1.293.gfe73786

