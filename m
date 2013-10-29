Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab3J2CEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 22:04:14 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:62650 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3J2CEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 22:04:13 -0400
MIME-Version: 1.0
Date: Tue, 29 Oct 2013 10:04:11 +0800
Message-ID: <CAPgLHd8oLgehkC-4LdRgiASnZGfk0u3ueVQw8f4J6g+3zeT5tQ@mail.gmail.com>
Subject: [PATCH] ARM: spear: fix return value check in spear_setup_of_timer()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: viresh.linux@gmail.com, shiraz.hashim@st.com, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function clk_get_sys() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-spear/time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-spear/time.c b/arch/arm/mach-spear/time.c
index d449673..3263a34 100644
--- a/arch/arm/mach-spear/time.c
+++ b/arch/arm/mach-spear/time.c
@@ -222,7 +222,7 @@ void __init spear_setup_of_timer(void)
 	}
 
 	gpt_clk = clk_get_sys("gpt0", NULL);
-	if (!gpt_clk) {
+	if (IS_ERR(gpt_clk)) {
 		pr_err("%s:couldn't get clk for gpt\n", __func__);
 		goto err_iomap;
 	}

