Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3AXJkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:40:05 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57211 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3AXJj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:39:57 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 1/1] pinctrl: core: Make pinctrl_release static
Date: Thu, 24 Jan 2013 15:01:00 +0530
Message-Id: <1359019860-3428-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'pinctrl_release' is used only in this file. Hence make it static.

Without this patch we get the following sparse error:
drivers/pinctrl/core.c:815:6: warning:
symbol 'pinctrl_release' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5a2fe9a..b0a8e9a 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -812,7 +812,7 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
  * pinctrl_release() - release the pinctrl handle
  * @kref: the kref in the pinctrl being released
  */
-void pinctrl_release(struct kref *kref)
+static void pinctrl_release(struct kref *kref)
 {
 	struct pinctrl *p = container_of(kref, struct pinctrl, users);
 
-- 
1.7.4.1

