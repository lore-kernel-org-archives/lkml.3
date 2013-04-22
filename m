Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3DVOfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:35:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51635 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755031Ab3DVOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Alban Bedel" <alban.bedel@avionic-design.de>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.672919477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [31/75] ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or
 ADC is running
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@avionic-design.de>

commit f1ca493b0b5e8f42d3b2dc8877860db2983f47b6 upstream.

The Charge Pump needs the DSP clock to work properly, without it the
bypass to HP/LINEOUT is not working properly. This requirement is not
mentioned in the datasheet but has been confirmed by Mark Brown from
Wolfson.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm8903.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1101,6 +1101,8 @@ static const struct snd_soc_dapm_route w
 	{ "ROP", NULL, "Right Speaker PGA" },
 	{ "RON", NULL, "Right Speaker PGA" },
 
+	{ "Charge Pump", NULL, "CLK_DSP" },
+
 	{ "Left Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Right Headphone Output PGA", NULL, "Charge Pump" },
 	{ "Left Line Output PGA", NULL, "Charge Pump" },

