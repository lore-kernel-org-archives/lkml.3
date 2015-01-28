Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbbA2J5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:57:07 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44790 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758758AbbA2JDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/176] ASoC: max98090: Fix ill-defined sidetone route
Date: Wed, 28 Jan 2015 15:27:20 +0100
Message-Id: <63c9d40707fd0073533385632ed50673811d608a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/max98090.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 764d0ea42e7c..9c20ef5f65d6 100644
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
2.2.2

