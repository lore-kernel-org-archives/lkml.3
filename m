Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab3EGECu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:02:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363Ab3EGD64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:56 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9PXbBuwz9VkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jorfG2Fu2p4A:10 a=wggVRkVUAAAA:8 a=VwQbUJbxAAAA:8 a=68HO0wZlerIDZT0grxAA:9 a=EAYKlQqjMvwA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035848.136043108@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [043/126] ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is
 running
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0043-ASoC-wm8903-Fix-the-bypass-to-HP-LINEOUT-when-no-DAC.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@avionic-design.de>

[ Upstream commit f1ca493b0b5e8f42d3b2dc8877860db2983f47b6 ]

The Charge Pump needs the DSP clock to work properly, without it the
bypass to HP/LINEOUT is not working properly. This requirement is not
mentioned in the datasheet but has been confirmed by Mark Brown from
Wolfson.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/codecs/wm8903.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 73f1c8d..3dfc582 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1083,6 +1083,8 @@ static const struct snd_soc_dapm_route wm8903_intercon[] = {
 	{ "ROP", NULL, "Right Speaker PGA" },
 	{ "RON", NULL, "Right Speaker PGA" },
 
+	{ "Charge Pump", NULL, "CLK_DSP" },
+
 	{ "Left Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Right Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Left Line Output PGA", NULL, "Charge Pump" },
-- 
1.7.10.4


