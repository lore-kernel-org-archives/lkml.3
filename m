Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaIZJq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbaIZJqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/142] ASoC: pxa: pxa-ssp: small leak in probe()
Date: Fri, 26 Sep 2014 11:44:51 +0200
Message-Id: <a9543fdd9338266f196d801aafdb2451fb6393f8.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4548728981de259d7d37d0ae968a777b09794168 upstream.

There is a small memory leak if probe() fails.

Fixes: 2023c90c3a2c ('ASoC: pxa: pxa-ssp: add DT bindings')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/pxa/pxa-ssp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/pxa/pxa-ssp.c b/sound/soc/pxa/pxa-ssp.c
index a3119a00d8fa..e4558e31a9ee 100644
--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -725,7 +725,8 @@ static int pxa_ssp_probe(struct snd_soc_dai *dai)
 		ssp_handle = of_parse_phandle(dev->of_node, "port", 0);
 		if (!ssp_handle) {
 			dev_err(dev, "unable to get 'port' phandle\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto err_priv;
 		}
 
 		priv->ssp = pxa_ssp_request_of(ssp_handle, "SoC audio");
-- 
2.1.0

