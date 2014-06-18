Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaFRR52 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 18 Jun 2014 13:57:28 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:12351 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbaFRR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:57:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0KAETSoVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZkogQsXdYRgIytvN4hGAc05hWKIL2QdhC0EmkOLMIgog0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] PCMCIA_HERMES: ioport_map/unmap relies on HAS_IOPORT_MAP
Date: Wed, 18 Jun 2014 19:55:38 +0200
Message-Id: <1403114138-7989-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing following sh-allmodconfig errors reported on kisskb

"
drivers/net/wireless/orinoco/orinoco_cs.c:153:2: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]
drivers/net/wireless/orinoco/orinoco_cs.c:205:3: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]
"

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/orinoco/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/orinoco/Kconfig b/drivers/net/wireless/orinoco/Kconfig
index 60819bc..d5ca942 100644
--- a/drivers/net/wireless/orinoco/Kconfig
+++ b/drivers/net/wireless/orinoco/Kconfig
@@ -107,7 +107,7 @@ config PCI_HERMES
 
 config PCMCIA_HERMES
 	tristate "Hermes PCMCIA card support"
-	depends on PCMCIA && HERMES
+	depends on PCMCIA && HERMES && HAS_IOPORT_MAP
 	---help---
 	  A driver for "Hermes" chipset based PCMCIA wireless adaptors, such
 	  as the Lucent WavelanIEEE/Orinoco cards and their OEM (Cabletron/
-- 
1.8.4.5

