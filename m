Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3C1L4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:56:31 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49100 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab3C1L4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:56:12 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: linux-kernel@vger.kernel.org, Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/3] pinctrl: pinctrl_select_state: set the old_state back on error
Date: Thu, 28 Mar 2013 12:55:48 +0100
Message-Id: <1364471748-23192-3-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
References: <1364471748-23192-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In unapply_new_state, the old state is re-applied, but p->state is not
set back as it should.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
This one can be squshed with commit:
50cf7c8ab324de348990bb028ad9ed10872d527a
pinctrl: re-enable old state in case of error in pinctrl_select_state
If needed.

 drivers/pinctrl/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 7c34937..714cf74 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -947,6 +947,8 @@ unapply_new_state:
 				pinmux_enable_setting(setting);
 		}
 	}
+
+	p->state = old_state;
 	return ret;
 }
 
-- 
1.7.2.5

