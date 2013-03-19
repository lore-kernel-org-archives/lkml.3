Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3CSESU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 00:18:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42862 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3CSEST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 00:18:19 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Subject: [PATCH 1/1] extcon: max77693: Staticize default_init_data
Date: Tue, 19 Mar 2013 09:37:16 +0530
Message-Id: <1363666036-14006-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0ec83bd246 ("extcon: max77693: Initialize register of MUIC
device to bring up it without platform data") added this structure
but forgot to make it static. Without this patch we get the following
warning:
drivers/extcon/extcon-max77693.c:41:26: warning:
symbol 'default_init_data' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 8f3c947..7b2e93d 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -38,7 +38,7 @@
  * extcon-max77693 driver use 'default_init_data' to bring up base operation
  * of MAX77693 MUIC device.
  */
-struct max77693_reg_data default_init_data[] = {
+static struct max77693_reg_data default_init_data[] = {
 	{
 		/* STATUS2 - [3]ChgDetRun */
 		.addr = MAX77693_MUIC_REG_STATUS2,
-- 
1.7.4.1

