Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab3JPM5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:57:32 -0400
Received: from mail.abilis.ch ([195.70.19.74]:28460 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab3JPM5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:57:30 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-doc@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>,
        devicetree@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH] Add a short note on pinctrl_get_group_pins to pinctrl.txt
Date: Wed, 16 Oct 2013 14:56:54 +0200
Message-Id: <1381928214-20916-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <CACRpkdbD9gJnF4C4ZeO2o0Q2RcL3w8=Hnu93EWJHyxUPwn29og@mail.gmail.com>
References: <CACRpkdbD9gJnF4C4ZeO2o0Q2RcL3w8=Hnu93EWJHyxUPwn29og@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a short description of how to use the newly added
pinctrl_get_group_pins function to the pinctrl documentation.

Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 Documentation/pinctrl.txt |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index c0ffd30..a7929cb 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -358,7 +358,12 @@ static struct pinctrl_gpio_range gpio_range = {
 	.gc = &chip;
 };
 
-In this case the pin_base property will be ignored.
+In this case the pin_base property will be ignored. If the name of a pin
+group is known, the pins and npins elements of the above structure can be
+initialised using the function pinctrl_get_group_pins(), e.g. for pin
+group "foo":
+
+pinctrl_get_group_pins(pctl, "foo", &gpio_range.pins, &gpio_range.npins);
 
 When GPIO-specific functions in the pin control subsystem are called, these
 ranges will be used to look up the appropriate pin controller by inspecting
-- 
1.7.1

