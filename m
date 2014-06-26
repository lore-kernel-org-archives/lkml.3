Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbaFZLbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:31:42 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53356 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbaFZLbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:31:41 -0400
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
Subject: [PATCH] pinctrl: pinctrl-st.c:  Cleaning up if unsigned is less than zero
Date: Thu, 26 Jun 2014 13:32:49 +0200
Message-Id: <1403782369-10201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking if a unsigned is less than zero

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/pinctrl/pinctrl-st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 1bd6363bc9..f4ee1b1 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1256,7 +1256,7 @@ static int st_pctl_parse_functions(struct device_node *np,
 	func = &info->functions[index];
 	func->name = np->name;
 	func->ngroups = of_get_child_count(np);
-	if (func->ngroups <= 0) {
+	if (func->ngroups == 0) {
 		dev_err(info->dev, "No groups defined\n");
 		return -EINVAL;
 	}
-- 
1.7.10.4

