Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LSIgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:36:16 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55797 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LSIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:36:15 -0500
Date: Thu, 19 Dec 2013 14:06:05 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-pcmcia@lists.infradead.org, josh@joshtriplett.org
Subject: [PATCH 3/3] drivers: pcmcia: Include appropriate header file in
 cardbus.c
Message-ID: <8b3e7f6a5ffdf104e316c5e1c848d7db34dd766e.1387387468.git.rashika.kheria@gmail.com>
References: <7fc39fa8a73bfcca6f379c6cd53cdb1659fc9d12.1387387468.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7fc39fa8a73bfcca6f379c6cd53cdb1659fc9d12.1387387468.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file cs_internal.h in cardbus.c because
functions cb_alloc() and cb_free() have their prototype declarations in
cs_internal.h.

This eliminates the following warnings in cardbus.c:
drivers/pcmcia/cardbus.c:67:11: warning: no previous prototype for ‘cb_alloc’ [-Wmissing-prototypes]
drivers/pcmcia/cardbus.c:105:6: warning: no previous prototype for ‘cb_free’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/pcmcia/cardbus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index b2a98cd..1c85f4b 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -25,7 +25,7 @@
 #include <linux/pci.h>
 
 #include <pcmcia/ss.h>
-
+#include "cs_internal.h"
 
 static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
 {
-- 
1.7.9.5

