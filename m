Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934967Ab3DGXd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:33:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46841 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934761Ab3DGXdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Markus Pargmann" <mpa@pengutronix.de>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.587931136@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [02/74] ASoC: imx-ssi: Fix occasional AC97 reset failure
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit b6e51600f4e983e757b1b6942becaa1ae7d82e67 upstream.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/imx/imx-ssi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/imx/imx-ssi.c
+++ b/sound/soc/imx/imx-ssi.c
@@ -573,6 +573,8 @@ static void imx_ssi_ac97_reset(struct sn
 
 	if (imx_ssi->ac97_reset)
 		imx_ssi->ac97_reset(ac97);
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 static void imx_ssi_ac97_warm_reset(struct snd_ac97 *ac97)
@@ -581,6 +583,9 @@ static void imx_ssi_ac97_warm_reset(stru
 
 	if (imx_ssi->ac97_warm_reset)
 		imx_ssi->ac97_warm_reset(ac97);
+
+	/* First read sometimes fails, do a dummy read */
+	imx_ssi_ac97_read(ac97, 0);
 }
 
 struct snd_ac97_bus_ops soc_ac97_ops = {

