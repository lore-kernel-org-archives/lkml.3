Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3FKItG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:49:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40672 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3FKItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:49:04 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH] pinctrl: abx500: fix build warning
Date: Tue, 11 Jun 2013 10:48:21 +0200
Message-Id: <1370940501-11029-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

pinctrl-abx500.c: In function 'abx500_gpio_dbg_show_one':
pinctrl-abx500.c:534:14: warning: 'pud' may be used
uninitialized in this function [-Wuninitialized]

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index a6992c3..dad03be 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -506,7 +506,7 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 	int mode = -1;
 	bool is_out;
 	bool pd;
-	enum abx500_gpio_pull_updown pud;
+	enum abx500_gpio_pull_updown pud = 0;
 
 	const char *modes[] = {
 		[ABX500_DEFAULT]	= "default",
-- 
1.7.10

