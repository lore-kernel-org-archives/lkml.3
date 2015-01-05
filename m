Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbbAEJBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:01:46 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32293 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbbAEJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:43 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4c-54aa52f4a099
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 02/14] mfd: hi6421-pmic: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:21 +0100
Message-id: <1420448493-9355-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xa7pfglaFGNzdJmvx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8abDytZCjrY
	KjrXb2BsYGxn7WLk5JAQMJH4drKdGcIWk7hwbz1bFyMXh5DAUkaJNxNmgiWEBPqYJA49NQWx
	2QSMJTYvX8IGYosIZEn8mLaaBcRmFjCU+PnuDzuILSzgJrHh5SkmEJtFQFXiwvk2sDgvUPzW
	9XuMEMvkJE4emwx0BAcHp4C7xO3HkSCmEFDJv7cJExh5FzAyrGIUTS1NLihOSs811CtOzC0u
	zUvXS87P3cQICZEvOxgXH7M6xCjAwajEw+txYmWIEGtiWXFl7iFGCQ5mJRHedbeAQrwpiZVV
	qUX58UWlOanFhxiZODilGhjDd9izd5xQ3/2e4/pfjYWXmK+t3RfJt+zk93nMan82BAgKXUu9
	t6Bw1/faMhW+q/f+fW3ozdcO1tjOVxhRUhTKN//MrKeqazuum59bfEZ97T+DOPO2x9s8JCuU
	HsRw2elHLFabk7bjz+6XH3WPKNl+Y3v3WNzzncTvrXc3CnUuMgxVK5j3Q55TiaU4I9FQi7mo
	OBEAsqh0+O8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/hi6421-pmic-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/hi6421-pmic-core.c b/drivers/mfd/hi6421-pmic-core.c
index 321a2656fd00..7210ae28bf81 100644
--- a/drivers/mfd/hi6421-pmic-core.c
+++ b/drivers/mfd/hi6421-pmic-core.c
@@ -35,7 +35,7 @@ static const struct mfd_cell hi6421_devs[] = {
 	{ .name = "hi6421-regulator", },
 };
 
-static struct regmap_config hi6421_regmap_config = {
+static const struct regmap_config hi6421_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 8,
-- 
1.9.1

