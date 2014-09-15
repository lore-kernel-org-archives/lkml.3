Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaIOTgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:36:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaIOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 086/158] ASoC: pxa: pxa-ssp: small leak in probe()
Date: Mon, 15 Sep 2014 12:25:25 -0700
Message-Id: <20140915192545.467294480@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4548728981de259d7d37d0ae968a777b09794168 upstream.

There is a small memory leak if probe() fails.

Fixes: 2023c90c3a2c ('ASoC: pxa: pxa-ssp: add DT bindings')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/pxa/pxa-ssp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -723,7 +723,8 @@ static int pxa_ssp_probe(struct snd_soc_
 		ssp_handle = of_parse_phandle(dev->of_node, "port", 0);
 		if (!ssp_handle) {
 			dev_err(dev, "unable to get 'port' phandle\n");
-			return -ENODEV;
+			ret = -ENODEV;
+			goto err_priv;
 		}
 
 		priv->ssp = pxa_ssp_request_of(ssp_handle, "SoC audio");


