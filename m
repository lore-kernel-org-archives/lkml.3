Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaLIBHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:07:48 -0500
Received: from m12-16.163.com ([220.181.12.16]:36242 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaLIBHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:07:47 -0500
X-Coremail-DSSMTP: 114.221.144.142
From: weiyj_lk@163.com
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Chao Xie <chao.xie@marvell.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] clk: mmp: fix sparse non static symbol warning
Date: Tue,  9 Dec 2014 09:07:30 +0800
Message-Id: <1418087250-14258-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowEDpvXFTS4ZUzHn6AQ--.2262S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUGw4DAryfGF4fZF1kKrg_yoWfGFX_ur
	ZIqrsxur1jkFyYyF1ku3W7Z34fZ3Z5ZF1qvFy2qr93A3y8Cr9xCr4v9rnrA3s8WrWDtFZF
	yrn5G3y8Gr1xAjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn6OJ5UUUUU==
X-Originating-IP: [114.221.144.142]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiox9d1lD+YGiQogAAsj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warnings:

drivers/clk/mmp/clk-frac.c:113:6: warning:
 symbol 'clk_factor_init' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/clk/mmp/clk-frac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index eeba52c..584a992 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -110,7 +110,7 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 	return 0;
 }
 
-void clk_factor_init(struct clk_hw *hw)
+static void clk_factor_init(struct clk_hw *hw)
 {
 	struct mmp_clk_factor *factor = to_clk_factor(hw);
 	struct mmp_clk_factor_masks *masks = factor->masks;

