Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbbALSF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57503 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbbALSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 046/216] ASoC: max98090: Fix ill-defined sidetone route
Date: Mon, 12 Jan 2015 18:02:43 +0000
Message-Id: <1421085933-32536-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 48826ee590da03e9882922edf96d8d27bdfe9552 upstream.

Commit 5fe5b767dc6f ("ASoC: dapm: Do not pretend to support controls for non
mixer/mux widgets") revealed ill-defined control in a route between
"STENL Mux" and DACs in max98090.c:

max98090 i2c-193C9890:00: Control not supported for path STENL Mux -> [NULL] -> DACL
max98090 i2c-193C9890:00: ASoC: no dapm match for STENL Mux --> NULL --> DACL
max98090 i2c-193C9890:00: ASoC: Failed to add route STENL Mux -> NULL -> DACL
max98090 i2c-193C9890:00: Control not supported for path STENL Mux -> [NULL] -> DACR
max98090 i2c-193C9890:00: ASoC: no dapm match for STENL Mux --> NULL --> DACR
max98090 i2c-193C9890:00: ASoC: Failed to add route STENL Mux -> NULL -> DACR

Since there is no control between "STENL Mux" and DACs the control name must
be NULL not "NULL".

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/max98090.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index d97f1ce7ff7d..39124f43faa1 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1403,8 +1403,8 @@ static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
 	{"STENL Mux", "Sidetone Left", "DMICL"},
 	{"STENR Mux", "Sidetone Right", "ADCR"},
 	{"STENR Mux", "Sidetone Right", "DMICR"},
-	{"DACL", "NULL", "STENL Mux"},
-	{"DACR", "NULL", "STENL Mux"},
+	{"DACL", NULL, "STENL Mux"},
+	{"DACR", NULL, "STENL Mux"},
 
 	{"AIFINL", NULL, "SHDN"},
 	{"AIFINR", NULL, "SHDN"},
-- 
2.1.4

