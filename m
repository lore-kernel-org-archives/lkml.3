Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbbANH0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:26:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbANH0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:26:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.18 019/150] ASoC: eukrea-tlv320: Fix of_node_put() call with uninitialized object
Date: Tue, 13 Jan 2015 23:21:30 -0800
Message-Id: <20150114072056.739714778@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/eukrea-tlv320.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -105,7 +105,7 @@ static int eukrea_tlv320_probe(struct pl
 	int ret;
 	int int_port = 0, ext_port;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *ssi_np, *codec_np;
+	struct device_node *ssi_np = NULL, *codec_np = NULL;
 
 	eukrea_tlv320.dev = &pdev->dev;
 	if (np) {


