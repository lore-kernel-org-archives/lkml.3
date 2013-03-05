Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907Ab3CEBDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:03:09 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:39759 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab3CEBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:03:08 -0500
Message-ID: <1362445374.4591.28.camel@lorien2>
Subject: [PATCH] net/wireless/brcm80211: remove PCI_BUS define from defs.h
 to fix warnings
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
        linville@tuxdriver.com, seth.forshee@canonical.com,
        pieterpg@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Mon, 04 Mar 2013 18:02:54 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI_BUS defined in defs.h results in warnings from all brcm80211 source files
including defs.h. This define is not used in brcm80211. Removing this define
fixes the warning.

In file included from drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:35:0:
drivers/net/wireless/brcm80211/include/defs.h:23:0: warning: "PCI_BUS" redefined [enabled by default]
include/uapi/linux/pci.h:36:0: note: this is the location of the previous definition
  CC [M]  drivers/net/wireless/b43legacy/dma.o
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.o
  CC [M]  drivers/net/wireless/b43legacy/pio.o
In file included from drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:29:0:
drivers/net/wireless/brcm80211/include/defs.h:23:0: warning: "PCI_BUS" redefined [enabled by default]
include/uapi/linux/pci.h:36:0: note: this is the location of the previous definition
In file included from drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c:29:0:
drivers/net/wireless/brcm80211/include/defs.h:23:0: warning: "PCI_BUS" redefined [enabled by default]
include/uapi/linux/pci.h:36:0: note: this is the location of the previous definition

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/net/wireless/brcm80211/include/defs.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index fb7cbcf..3608436 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -20,7 +20,6 @@
 #include <linux/types.h>
 
 #define	SI_BUS			0
-#define	PCI_BUS			1
 #define	PCMCIA_BUS		2
 #define SDIO_BUS		3
 #define JTAG_BUS		4
-- 
1.7.9.5



