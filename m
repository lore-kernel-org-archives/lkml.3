Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3KHCWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:22:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab3KHCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 70/91] ASoC: dapm: Fix source list debugfs outputs
Date: Thu,  7 Nov 2013 18:15:25 -0800
Message-Id: <1383876946-2396-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ff18620c2157671a8ee21ebb8e6a3520ea209b1f upstream.

... due to a copy & paste error.

Spotted by coverity CID 710923.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 258acad..f8495ef 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1766,7 +1766,7 @@ static ssize_t dapm_widget_power_read_file(struct file *file,
 				w->active ? "active" : "inactive");
 
 	list_for_each_entry(p, &w->sources, list_sink) {
-		if (p->connected && !p->connected(w, p->sink))
+		if (p->connected && !p->connected(w, p->source))
 			continue;
 
 		if (p->connect)
-- 
1.8.1.2

