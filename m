Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064AbaKNCML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 21:12:11 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:8351 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518AbaKNCMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 21:12:09 -0500
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        "Tianhong Ding" <dingtianhong@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] clk: delete a local variable's repeated assignment
Date: Fri, 14 Nov 2014 10:10:40 +0800
Message-ID: <1415931040-9868-1-git-send-email-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.546564F7.01ED,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: f32cef477ec5a3750e0dbbc51e0c1d3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the same to the next statement, "ret = clk->parent". I think compiler will
optimize it, it's just not looking well.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/clk/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4896ae9..5307225 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1614,7 +1614,7 @@ static struct clk *__clk_init_parent(struct clk *clk)

 	if (clk->num_parents == 1) {
 		if (IS_ERR_OR_NULL(clk->parent))
-			ret = clk->parent = __clk_lookup(clk->parent_names[0]);
+			clk->parent = __clk_lookup(clk->parent_names[0]);
 		ret = clk->parent;
 		goto out;
 	}
--
1.8.0


