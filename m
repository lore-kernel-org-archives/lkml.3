Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbbANHef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:34:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbbANHeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.14 16/77] ASoC: max98090: Fix ill-defined sidetone route
Date: Tue, 13 Jan 2015 23:22:56 -0800
Message-Id: <20150114072225.059523110@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98090.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -1378,8 +1378,8 @@ static const struct snd_soc_dapm_route m
 	{"STENL Mux", "Sidetone Left", "DMICL"},
 	{"STENR Mux", "Sidetone Right", "ADCR"},
 	{"STENR Mux", "Sidetone Right", "DMICR"},
-	{"DACL", "NULL", "STENL Mux"},
-	{"DACR", "NULL", "STENL Mux"},
+	{"DACL", NULL, "STENL Mux"},
+	{"DACR", NULL, "STENL Mux"},
 
 	{"AIFINL", NULL, "SHDN"},
 	{"AIFINR", NULL, "SHDN"},


