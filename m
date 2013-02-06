Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab3BFQ0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:26:10 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:39286 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab3BFQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:22 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:24:00 +0100
Message-Id: <1360167843-3587-13-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 13020616-0542-0000-0000-00000455E6E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix these two compile errors on s390 which does not have HAS_IOPORT
nor GENERIC_HARDIRQS:

sound/pci/lx6464es/lx6464es.c: In function ‘snd_lx6464es_free’:
sound/pci/lx6464es/lx6464es.c:565:2: error: implicit declaration of function ‘ioport_unmap’

sound/soc/codecs/wm8903.c: In function ‘wm8903_set_pdata_irq_trigger’:
sound/soc/codecs/wm8903.c:1954:9: error: implicit declaration of function ‘irq_get_irq_data’

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 sound/pci/Kconfig        |    1 +
 sound/soc/codecs/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 947cfb4..fe6fa93 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -678,6 +678,7 @@ config SND_LOLA
 
 config SND_LX6464ES
 	tristate "Digigram LX6464ES"
+	depends on HAS_IOPORT
 	select SND_PCM
 	help
 	  Say Y here to include support for Digigram LX6464ES boards.
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 298822c..65e3c6a 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -98,7 +98,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_WM8782
 	select SND_SOC_WM8804 if SND_SOC_I2C_AND_SPI
 	select SND_SOC_WM8900 if I2C
-	select SND_SOC_WM8903 if I2C
+	select SND_SOC_WM8903 if I2C && GENERIC_HARDIRQS
 	select SND_SOC_WM8904 if I2C
 	select SND_SOC_WM8940 if I2C
 	select SND_SOC_WM8955 if I2C
-- 
1.7.10.4

