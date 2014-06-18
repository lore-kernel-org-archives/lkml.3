Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaFRRt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:49:26 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:54885 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbaFRRtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:49:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0KAJ/QoVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZkogQsXdYRgI4EaN4hGAc0+hWKIL2QdhC0EmkOLMIgog0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        "John W. Linville" <linville@tuxdriver.com>,
        Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] LIBERTAS_CS: ioport_map/unmap relies on HAS_IOPORT_MAP
Date: Wed, 18 Jun 2014 19:48:02 +0200
Message-Id: <1403113682-7787-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing following sh-allmodconfig errors reported on kisskb

"
drivers/net/wireless/libertas/if_cs.c:826:3: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]
drivers/net/wireless/libertas/if_cs.c:878:2: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]
"

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 drivers/net/wireless/libertas/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/Kconfig b/drivers/net/wireless/libertas/Kconfig
index 0485c99..e6268ce 100644
--- a/drivers/net/wireless/libertas/Kconfig
+++ b/drivers/net/wireless/libertas/Kconfig
@@ -16,7 +16,7 @@ config LIBERTAS_USB
 
 config LIBERTAS_CS
 	tristate "Marvell Libertas 8385 CompactFlash 802.11b/g cards"
-	depends on LIBERTAS && PCMCIA
+	depends on LIBERTAS && PCMCIA && HAS_IOPORT_MAP
 	---help---
 	  A driver for Marvell Libertas 8385 CompactFlash devices.
 
-- 
1.8.4.5

