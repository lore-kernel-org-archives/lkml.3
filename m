Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbbA0MRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34992 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423AbbA0MRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 037/126] ASoC: eukrea-tlv320: Fix of_node_put() call with uninitialized object
Date: Tue, 27 Jan 2015 12:15:42 +0000
Message-Id: <1422361031-19364-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 077661b6ed24e530dabc9db3ab3ae48fbaf19679 upstream.

The of_node_put() call in eukrea_tlv320_probe() may take an
uninitialized pointer, as compiler spotted out:
  sound/soc/fsl/eukrea-tlv320.c:221:14: warning: 'ssi_np' may be used uninitialized in this function [-Wuninitialized]

This patch adds the proper NULL initializations as a fix.
(codec_np is also NULL initialized just for consistency.)

Fixes: 66f232908de2 ('ASoC: eukrea-tlv320: Add DT support')
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/fsl/eukrea-tlv320.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/eukrea-tlv320.c b/sound/soc/fsl/eukrea-tlv320.c
index eb093d5b85c4..54790461f39e 100644
--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -105,7 +105,7 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 	int ret;
 	int int_port = 0, ext_port;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ssi_np, *codec_np;
+	struct device_node *ssi_np = NULL, *codec_np = NULL;
 
 	eukrea_tlv320.dev = &pdev->dev;
 	if (np) {
-- 
2.1.4

