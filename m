Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3HKSDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:03:24 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53216 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3HKSAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 14:00:00 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 07/18] dmaengine: PL08x: Fix reading the byte count in cctl
Date: Sun, 11 Aug 2013 19:59:19 +0200
Message-Id: <1376243970-6489-8-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Bedel <alban.bedel@avionic-design.de>

There are more fields than just SWIDTH in CH_CONTROL register, so read
register value must be masked in addition to shifting.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 4e4c3df..6b9cba2 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -480,6 +480,8 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 	/* The source width defines the number of bytes */
 	u32 bytes = cctl & PL080_CONTROL_TRANSFER_SIZE_MASK;
 
+	cctl &= PL080_CONTROL_SWIDTH_MASK;
+
 	switch (cctl >> PL080_CONTROL_SWIDTH_SHIFT) {
 	case PL080_WIDTH_8BIT:
 		break;
@@ -498,6 +500,8 @@ static inline u32 get_bytes_in_cctl_pl080s(u32 cctl, u32 cctl1)
 	/* The source width defines the number of bytes */
 	u32 bytes = cctl1 & PL080S_CONTROL_TRANSFER_SIZE_MASK;
 
+	cctl &= PL080_CONTROL_SWIDTH_MASK;
+
 	switch (cctl >> PL080_CONTROL_SWIDTH_SHIFT) {
 	case PL080_WIDTH_8BIT:
 		break;
-- 
1.8.3.2

