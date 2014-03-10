Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaCJIdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:33:44 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17541 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaCJIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:33:03 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-bb-531d78be64fd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 8/8] regulator: max8973: Remove unused field from 'struct
 max8973_chip'
Date: Mon, 10 Mar 2014 09:32:51 +0100
Message-id: <1394440371-29588-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7r7KmSDDeYv5baY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvn13ewF
	t9gqzuw5xdrAeIi1i5GTQ0LAROLip6UsELaYxIV769m6GLk4hASWMkqsnn2HFcLpY5Jov3SZ
	CaSKTcBYYvPyJWwgtohAhsTmeVPBJjELGEr8fPeHHcQWFoiUWD/lOCOIzSKgKnFg3RuwOK+A
	u0TvvbtA9RxA2xQk5kyyAQlzCnhILNpzC6xECKhkd+cOlgmMvAsYGVYxiqaWJhcUJ6XnGuoV
	J+YWl+al6yXn525ihITKlx2Mi49ZHWIU4GBU4uE98FYmWIg1say4MvcQowQHs5IIb0acbLAQ
	b0piZVVqUX58UWlOavEhRiYOTqkGxl5d7uBwjsX1Ni+CffXZjT8+PpH+/c6+g0vW3qnvebtH
	/Lvz0zb25StM33U/NZs0L/jKS2FzQ02/3G8q02t+RLyT9fPK45JZd+lG/4WG0q1qy/64X/p9
	f2Kup+VNvhcnbesWqJkaTGNf5L0w7Zm7QeRM+/z3G4TDPip+YUuWefk3yMH2zCrVIiWW4oxE
	Qy3mouJEAJimHzPzAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'struct regulator_dev *rdev' of 'struct max8973_chip' isn't used
anywhere in the driver so it can be removed safely.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8973-regulator.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index 892aa1e5b96c..552fb6d1850c 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -93,7 +93,6 @@
 struct max8973_chip {
 	struct device *dev;
 	struct regulator_desc desc;
-	struct regulator_dev *rdev;
 	struct regmap *regmap;
 	bool enable_external_control;
 	int dvs_gpio;
@@ -474,7 +473,6 @@ static int max8973_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	max->rdev = rdev;
 	return 0;
 }
 
-- 
1.7.9.5

