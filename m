Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3ILHdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:33:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:24034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab3ILHdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,889,1371106800"; 
   d="scan'208";a="402180069"
From: tianyu.lan@intel.com
To: tianyu.lan@intel.com, lenb@kernel.org, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ACPI/Button: Using input_set_capability() to mark device's event capability
Date: Thu, 12 Sep 2013 03:32:03 -0400
Message-Id: <1378971125-8896-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1378971125-8896-1-git-send-email-tianyu.lan@intel.com>
References: <1378971125-8896-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

Input layer provides input_set_capability() to set input device's event
related bits. This patch is to use it to replace origin code.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/button.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index a557738..c971929 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -383,18 +383,15 @@ static int acpi_button_add(struct acpi_device *device)
 
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:
-		input->evbit[0] = BIT_MASK(EV_KEY);
-		set_bit(KEY_POWER, input->keybit);
+		input_set_capability(input, EV_KEY, KEY_POWER);
 		break;
 
 	case ACPI_BUTTON_TYPE_SLEEP:
-		input->evbit[0] = BIT_MASK(EV_KEY);
-		set_bit(KEY_SLEEP, input->keybit);
+		input_set_capability(input, EV_KEY, KEY_SLEEP);
 		break;
 
 	case ACPI_BUTTON_TYPE_LID:
-		input->evbit[0] = BIT_MASK(EV_SW);
-		set_bit(SW_LID, input->swbit);
+		input_set_capability(input, EV_SW, SW_LID);
 		break;
 	}
 
-- 
1.8.2.1

