Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaBRPhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:37:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50448 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086AbaBRPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:30:45 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: [PATCH 02/17 v2] ASoC: dapm: Add helpers to lock/unlock DAPM mutex
Date: Tue, 18 Feb 2014 15:22:13 +0000
Message-Id: <1392736948-26623-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acquiring the DAPM mutex is necessary before using several DAPM
functions and dereference is quite ugly. This patch provides a helper
function to simplify this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 include/sound/soc.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 21038e0..dc46623 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1204,4 +1204,15 @@ extern struct dentry *snd_soc_debugfs_root;
 
 extern const struct dev_pm_ops snd_soc_pm_ops;
 
+/* Helper functions */
+static inline void snd_soc_dapm_mutex_lock(struct snd_soc_dapm_context *dapm)
+{
+	mutex_lock(&dapm->card->dapm_mutex);
+}
+
+static inline void snd_soc_dapm_mutex_unlock(struct snd_soc_dapm_context *dapm)
+{
+	mutex_unlock(&dapm->card->dapm_mutex);
+}
+
 #endif
-- 
1.7.2.5

