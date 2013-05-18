Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3ERCSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3ERCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:58 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uWM6xm5buWAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3oGaB7CePIcA:10 a=cm27Pg_UAAAA:8 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=zv9_9hqRWm8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021649.973304026@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dylan Reid <dgreid@chromium.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 051/136 ] ASoC: max98088: Fix logging of hardware revision.
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0051-ASoC-max98088-Fix-logging-of-hardware-revision.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

[ Upstream commit 98682063549bedd6e2d2b6b7222f150c6fbce68c ]

The hardware revision of the codec is based at 0x40.  Subtract that
before convering to ASCII.  The same as it is done for 98095.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/codecs/max98088.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index af7324b..4790568 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -2006,7 +2006,7 @@ static int max98088_probe(struct snd_soc_codec *codec)
                        ret);
                goto err_access;
        }
-       dev_info(codec->dev, "revision %c\n", ret + 'A');
+       dev_info(codec->dev, "revision %c\n", ret - 0x40 + 'A');
 
        snd_soc_write(codec, M98088_REG_51_PWR_SYS, M98088_PWRSV);
 
-- 
1.7.10.4


