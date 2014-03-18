Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaCRXvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 19:51:18 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8767 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaCRXvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:51:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Mar 2014 16:47:32 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>,
        Songhee Baek <sbaek@nvidia.com>
Subject: [PATCH] ASoC: Add support for multi register mux
Date: Tue, 18 Mar 2014 16:51:32 -0700
Message-ID: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently soc_enum structure supports only 2 registers (reg, reg2)
for kcontrol. However, it is possible to have multiple registers
per mux. This change allows us to control these multiple registers.

Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
Signed-off-by: Songhee Baek <sbaek@nvidia.com>
---
 include/sound/soc.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 9a00147..ddedfb4 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1093,6 +1093,9 @@ struct soc_enum {
 	unsigned int mask;
 	const char * const *texts;
 	const unsigned int *values;
+	unsigned int *regs;
+	unsigned int *masks;
+	unsigned int num_regs;
 };
 
 /* codec IO */
-- 
1.7.9.5

