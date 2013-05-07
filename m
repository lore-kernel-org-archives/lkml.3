Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3EGMGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:06:23 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50437 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3EGMGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:06:20 -0400
MIME-Version: 1.0
Date: Tue, 7 May 2013 20:06:19 +0800
Message-ID: <CAPgLHd-av2Yg44ARcSGr_zOajO-U611y3N4_Sn7J5Z+=OfVFcg@mail.gmail.com>
Subject: [PATCH] pinctrl: single: fix error return code in pcs_parse_one_pinctrl_entry()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        haojian.zhuang@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Introduced by commit 9dddb4df90d136429b6d6ddefceb49a9b93f6cd1
(pinctrl: single: support generic pinconf)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-single.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 5f2d2bf..b9fa046 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1166,7 +1166,8 @@ static int pcs_parse_one_pinctrl_entry(struct pcs_device *pcs,
 	(*map)->data.mux.function = np->name;
 
 	if (pcs->is_pinconf) {
-		if (pcs_parse_pinconf(pcs, np, function, map))
+		res = pcs_parse_pinconf(pcs, np, function, map);
+		if (res)
 			goto free_pingroups;
 		*num_maps = 2;
 	} else {

