Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab3LXBMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:12:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49662 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab3LXBMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:12:43 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 01/15] reset: Silence warning in reset-controller.h
Date: Mon, 23 Dec 2013 17:12:25 -0800
Message-Id: <1387847559-18330-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user of <linux/reset-controller.h> doesn't include
<linux/of.h> before including reset-controller.h they'll get a
warning as follows:

  include/linux/reset-controller.h:44:17:
  warning: 'struct of_phandle_args' declared inside parameter list

This is because of_phandle_args is not forward declared. Add the
declaration to silence this warning.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/reset-controller.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
index 2f61311..41a4695 100644
--- a/include/linux/reset-controller.h
+++ b/include/linux/reset-controller.h
@@ -21,6 +21,7 @@ struct reset_control_ops {
 
 struct module;
 struct device_node;
+struct of_phandle_args;
 
 /**
  * struct reset_controller_dev - reset controller entity that might
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

