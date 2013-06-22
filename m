Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3FVUoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:44:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3FVUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:27 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH v2 06/12] dmaengine: PL08x: Fix reading the byte count in cctl
Date: Sat, 22 Jun 2013 22:42:38 +0200
Message-Id: <1371933764-24875-7-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Bedel <alban.bedel@avionic-design.de>

There are more fields than just SWIDTH in CH_CONTROL register, so read
register value must be masked in addition to shifting.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/dma/amba-pl08x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 89b8120..1eeb911 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -469,6 +469,8 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
 	/* The source width defines the number of bytes */
 	u32 bytes = cctl & PL080_CONTROL_TRANSFER_SIZE_MASK;
 
+	cctl &= PL080_CONTROL_SWIDTH_MASK;
+
 	switch (cctl >> PL080_CONTROL_SWIDTH_SHIFT) {
 	case PL080_WIDTH_8BIT:
 		break;
@@ -487,6 +489,8 @@ static inline u32 get_bytes_in_cctl_pl080s(u32 cctl, u32 cctl1)
 	/* The source width defines the number of bytes */
 	u32 bytes = cctl1 & PL080S_CONTROL_TRANSFER_SIZE_MASK;
 
+	cctl &= PL080_CONTROL_SWIDTH_MASK;
+
 	switch (cctl >> PL080_CONTROL_SWIDTH_SHIFT) {
 	case PL080_WIDTH_8BIT:
 		break;
-- 
1.8.2.1

