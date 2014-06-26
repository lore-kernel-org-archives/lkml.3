Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaFZNn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:43:27 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:59443 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaFZNn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:43:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-st.c:  Cleaning up values that are never used
Date: Thu, 26 Jun 2014 15:44:32 +0200
Message-Id: <1403790272-11635-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable that are never used

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-st.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 1bd6363bc9..d3bd687 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1178,9 +1178,7 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
 	const __be32 *list;
 	struct property *pp;
 	struct st_pinconf *conf;
-	phandle phandle;
 	struct device_node *pins;
-	u32 pin;
 	int i = 0, npins = 0, nr_props;
 
 	pins = of_get_child_by_name(np, "st,pins");
@@ -1218,8 +1216,8 @@ static int st_pctl_dt_parse_groups(struct device_node *np,
 		conf = &grp->pin_conf[i];
 
 		/* bank & offset */
-		phandle = be32_to_cpup(list++);
-		pin = be32_to_cpup(list++);
+		be32_to_cpup(list++);
+		be32_to_cpup(list++);
 		conf->pin = of_get_named_gpio(pins, pp->name, 0);
 		conf->name = pp->name;
 		grp->pins[i] = conf->pin;
-- 
1.7.10.4

