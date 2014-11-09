Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaKITrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 14:47:12 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:6083 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaKITrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 14:47:09 -0500
X-Mailbox-Line: From d5d74f6993e9f2392008a27a2938c58d47dc8062 Mon Sep 17 00:00:00 2001
Message-Id: <d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
In-Reply-To: <cover.1415562021.git.moinejf@free.fr>
References: <cover.1415562021.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 9 Nov 2014 20:33:45 +0100
Subject: [PATCH v2 1/2] ASoC: Remove 'const' from the device_node pointers
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Russell King:
of_node_put() modifies the struct device_node contents.  Therefore,
of_node_put() definitely not treating the data pointed to as read-only,
and therefore it is completely inappropriate for it to be marked "const".

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 include/sound/soc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 7ba7130..405f967 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -886,7 +886,7 @@ struct snd_soc_platform_driver {
 
 struct snd_soc_dai_link_component {
 	const char *name;
-	const struct device_node *of_node;
+	struct device_node *of_node;
 	const char *dai_name;
 };
 
@@ -990,7 +990,7 @@ struct snd_soc_codec_conf {
 	 * DT/OF node, but not both.
 	 */
 	const char *dev_name;
-	const struct device_node *of_node;
+	struct device_node *of_node;
 
 	/*
 	 * optional map of kcontrol, widget and path name prefixes that are
@@ -1007,7 +1007,7 @@ struct snd_soc_aux_dev {
 	 * DT/OF node, but not both.
 	 */
 	const char *codec_name;
-	const struct device_node *codec_of_node;
+	struct device_node *codec_of_node;
 
 	/* codec/machine specific init - e.g. add machine controls */
 	int (*init)(struct snd_soc_component *component);
-- 
2.1.3

