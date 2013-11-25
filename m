Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3KYNHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:07:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3KYNHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 24/78] ASoC: dapm: Fix source list debugfs outputs
Date: Mon, 25 Nov 2013 13:06:11 +0000
Message-Id: <1385384825-21681-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ff18620c2157671a8ee21ebb8e6a3520ea209b1f upstream.

... due to a copy & paste error.

Spotted by coverity CID 710923.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 9ddc1a8..8423a2a 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1692,7 +1692,7 @@ static ssize_t dapm_widget_power_read_file(struct file *file,
 				w->active ? "active" : "inactive");
 
 	list_for_each_entry(p, &w->sources, list_sink) {
-		if (p->connected && !p->connected(w, p->sink))
+		if (p->connected && !p->connected(w, p->source))
 			continue;
 
 		if (p->connect)
-- 
1.8.3.2

