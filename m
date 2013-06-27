Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3F0M41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:56:27 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:4359 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3F0M4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:56:24 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jiri Kosina <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Bill Pemberton <wfp5p@virginia.edu>, <alsa-devel@alsa-project.org>
Subject: [PATCH 3/6] sound/pci:trivial: replace numeric with standard PM state macros
Date: Thu, 27 Jun 2013 20:55:11 +0800
Message-ID: <1372337711-26220-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard PM state macros PCI_Dx instead of numeric 0/1/2..

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
---
 sound/pci/cs4281.c             |    2 +-
 sound/pci/ens1370.c            |    2 +-
 sound/pci/ymfpci/ymfpci_main.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 6a86950..2f6a4b6 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1312,7 +1312,7 @@ static int snd_cs4281_free(struct cs4281 *chip)
 	/* Sound System Power Management - Turn Everything OFF */
 	snd_cs4281_pokeBA0(chip, BA0_SSPM, 0);
 	/* PCI interface - D3 state */
-	pci_set_power_state(chip->pci, 3);
+	pci_set_power_state(chip->pci, PCI_D3hot);
 
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index db2dc83..b30afd1 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -1939,7 +1939,7 @@ static int snd_ensoniq_free(struct ensoniq *ensoniq)
 #endif
 	if (ensoniq->irq >= 0)
 		synchronize_irq(ensoniq->irq);
-	pci_set_power_state(ensoniq->pci, 3);
+	pci_set_power_state(ensoniq->pci, PCI_D3hot);
       __hw_end:
 #ifdef CHIP1370
 	if (ensoniq->dma_bug.area)
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 22056c5..d591c15 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -2258,7 +2258,7 @@ static int snd_ymfpci_free(struct snd_ymfpci *chip)
 	/* FIXME: temporarily disabled, otherwise we cannot fire up
 	 * the chip again unless reboot.  ACPI bug?
 	 */
-	pci_set_power_state(chip->pci, 3);
+	pci_set_power_state(chip->pci, PCI_D3hot);
 #endif
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.1


