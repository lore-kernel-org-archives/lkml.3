Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764086AbbA2DUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:20:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762103AbbA2Cfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 045/139] ASoC: max98090: Fix ill-defined sidetone route
Date: Wed, 28 Jan 2015 14:19:48 -0800
Message-Id: <1422483682-15393-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/max98090.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 764d0ea..9c20ef5 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1378,8 +1378,8 @@ static const struct snd_soc_dapm_route max98090_dapm_routes[] = {
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
1.9.1

