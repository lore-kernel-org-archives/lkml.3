Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945912Ab3BGWmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:42:40 -0500
Received: from mout.gmx.net ([212.227.15.19]:52097 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422737Ab3BGWmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:42:38 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19ixId7ayRiMGShhuc3BMMc877NMMngXHizqRT8x5
	rp1AQHXJcm69C/
From: Peter Huewe <peterhuewe@gmx.de>
To: Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/goldfish: Add MTD dependency to KCONFIG
Date: Thu,  7 Feb 2013 23:46:38 +0100
Message-Id: <1360277198-18246-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <5113FAAE.4070501@infradead.org>
References: <5113FAAE.4070501@infradead.org>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MTD is not set goldfish_nand fails to compile with the
following linker warnings:

drivers/built-in.o: In function `goldfish_nand_remove':
goldfish_nand.c:(.text+0x6e7d0e): undefined reference to
`mtd_device_unregister'
drivers/built-in.o: In function `goldfish_nand_erase':
goldfish_nand.c:(.text+0x6e8ba2): undefined reference to
`mtd_erase_callback'
drivers/built-in.o: In function `goldfish_nand_init_device':
goldfish_nand.c:(.text+0x6e8eba): undefined reference to
`mtd_device_parse_register'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
@Randy: The contact info you're looking for is in CC of this mail.

 drivers/staging/goldfish/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/goldfish/Kconfig b/drivers/staging/goldfish/Kconfig
index d6c98d0..4e09460 100644
--- a/drivers/staging/goldfish/Kconfig
+++ b/drivers/staging/goldfish/Kconfig
@@ -7,6 +7,7 @@ config GOLDFISH_AUDIO
 config MTD_GOLDFISH_NAND
 	tristate "Goldfish NAND device"
 	depends on GOLDFISH
+	depends on MTD
 	help
 	  Drives the emulated NAND flash device on the Google Goldfish
 	  Android virtual device.
-- 
1.7.8.6

