Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3DOCnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:43:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3DOCne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 04/27] ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running
Date: Sun, 14 Apr 2013 19:43:03 -0700
Message-Id: <20130415024231.682140418@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@avionic-design.de>

commit f1ca493b0b5e8f42d3b2dc8877860db2983f47b6 upstream.

The Charge Pump needs the DSP clock to work properly, without it the
bypass to HP/LINEOUT is not working properly. This requirement is not
mentioned in the datasheet but has been confirmed by Mark Brown from
Wolfson.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8903.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1083,6 +1083,8 @@ static const struct snd_soc_dapm_route w
 	{ "ROP", NULL, "Right Speaker PGA" },
 	{ "RON", NULL, "Right Speaker PGA" },
 
+	{ "Charge Pump", NULL, "CLK_DSP" },
+
 	{ "Left Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Right Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Left Line Output PGA", NULL, "Charge Pump" },


