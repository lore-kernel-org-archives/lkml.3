Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaLHVvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:51:54 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55965 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLHVvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:51:53 -0500
From: Olof Johansson <olof@lixom.net>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        f.fainelli@gmail.com, Olof Johansson <olof@lixom.net>
Subject: [PATCH 1/2] clk: bcm: kona: don't return -EFOO as bool
Date: Mon,  8 Dec 2014 13:54:04 -0800
Message-Id: <1418075645-14571-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with sparse:

drivers/clk/bcm/clk-kona.c:1255:16: warning: odd constant _Bool cast (ffffffffffffffea becomes 1)

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/clk/bcm/clk-kona.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 95af2e6..53fca77 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1252,7 +1252,7 @@ static bool __kona_clk_init(struct kona_clk *bcm_clk)
 	default:
 		BUG();
 	}
-	return -EINVAL;
+	return false;
 }
 
 /* Set a CCU and all its clocks into their desired initial state */
-- 
1.7.10.4

