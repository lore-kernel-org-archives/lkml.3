Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaLDKd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:33:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:49371 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbaLDKdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:33:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="648157362"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/2] pinctrl: intel: Pass CONFIG_DEBUG_PINCTRL to drivers
Date: Thu,  4 Dec 2014 12:32:49 +0200
Message-Id: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user has selected CONFIG_DEBUG_PINCTRL=y make sure that Intel
pinctrl drivers will be compiled with that option as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pinctrl/intel/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/intel/Makefile b/drivers/pinctrl/intel/Makefile
index 4c210e4139e2..1f63cf1c18b2 100644
--- a/drivers/pinctrl/intel/Makefile
+++ b/drivers/pinctrl/intel/Makefile
@@ -1,4 +1,6 @@
 # Intel pin control drivers
 
+ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
+
 obj-$(CONFIG_PINCTRL_BAYTRAIL)		+= pinctrl-baytrail.o
 obj-$(CONFIG_PINCTRL_CHERRYVIEW)	+= pinctrl-cherryview.o
-- 
2.1.3

