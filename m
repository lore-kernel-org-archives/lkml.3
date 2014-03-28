Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaC1Rau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:30:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaC1Rak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 08/22] ASoC: max98090: make REVISION_ID readable
Date: Fri, 28 Mar 2014 10:32:00 -0700
Message-Id: <20140328173110.545201214@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit e126a646f77fdd66978785cb0a3a5e46b07aee2e upstream.

The REVISION_ID register is not currently marked readable. snd_soc_read()
refuses to read the register, and hence probe() fails.

Fixes: d4807ad2c4c0 ("regmap: Check readable regs in _regmap_read")
[exposed the bug, by checking for readability]
Fixes: 685e42154dcf ("ASoC: Replace max98090 Device Driver")
[left out this register from the readable list]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98090.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -336,6 +336,7 @@ static bool max98090_readable_register(s
 	case M98090_REG_RECORD_TDM_SLOT:
 	case M98090_REG_SAMPLE_RATE:
 	case M98090_REG_DMIC34_BIQUAD_BASE ... M98090_REG_DMIC34_BIQUAD_BASE + 0x0E:
+	case M98090_REG_REVISION_ID:
 		return true;
 	default:
 		return false;


