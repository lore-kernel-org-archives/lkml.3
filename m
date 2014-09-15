Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaIOTfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:35:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaIOT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 089/158] ASoC: rt5640: Do not allow regmap to use bulk read-write operations
Date: Mon, 15 Sep 2014 12:25:28 -0700
Message-Id: <20140915192545.554099529@linuxfoundation.org>
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit f4821e8e8e957fe4c601a49b9a97b7399d5f7ab1 upstream.

Debugging showed Realtek RT5642 doesn't support autoincrementing writes so
driver should set the use_single_rw flag for regmap.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/rt5640.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2059,6 +2059,7 @@ static struct snd_soc_codec_driver soc_c
 static const struct regmap_config rt5640_regmap = {
 	.reg_bits = 8,
 	.val_bits = 16,
+	.use_single_rw = true,
 
 	.max_register = RT5640_VENDOR_ID2 + 1 + (ARRAY_SIZE(rt5640_ranges) *
 					       RT5640_PR_SPACING),


