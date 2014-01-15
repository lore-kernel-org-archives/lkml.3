Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaAOSrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:47:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49368 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaAOSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH v5 01/14] reset: Silence warning in reset-controller.h
Date: Wed, 15 Jan 2014 10:47:21 -0800
Message-Id: <1389811654-21397-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
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

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/linux/reset-controller.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/reset-controller.h b/include/linux/reset-controller.h
index 2f61311ae3e0..41a4695fde08 100644
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

