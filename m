Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3GHNAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:00:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64425 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3GHNAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:00:00 -0400
X-AuditID: cbfee68e-b7f276d000002279-01-51dab7ce1540
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sbkim73@samsung.com, broonie@kernel.org, lgirdwood@gmail.com,
        sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, sachin.kamat@linaro.org,
        yadi.brar01@gmail.com, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [v2 PATCH 5/6] regulator: core: Remove redundant checks
Date: Sat, 29 Jun 2013 18:21:19 +0530
Message-id: <1372510280-31931-6-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
References: <1372510280-31931-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSrXt++61AgzU5FlMfPmGzOPBnB6PF
	tysdTBaXd81hszi84gCTxck/vYwWp7tZLS6u+MJkMfd3I6vFnOnvmBy4PBZ8vsLusXPWXXaP
	Tas62TzuXNvD5jHvZKBH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZcx6cICt4AJXxZLmPawN
	jA2cXYycHBICJhJfZ09hgbDFJC7cW8/WxcjFISSwlFFiztZ7bDBFf/89YYZILGKUODZnFztI
	QkigjUniyOfSLkYODjYBI4lXx+xAwiICChKbe5+xgtQzC7xllFi69AbYBmEBB4nHrYvAelkE
	VCVmfL4MZvMKuEocWHmHFWKZgkTrskNgcU4BN4muydeZIHa5Snzc084EMlRC4BC7xNbd59gg
	BglIfJt8iAXkCAkBWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ
	+bmbGIExcfrfs74djDcPWB9iTAYaN5FZSjQ5HxhTeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpg1OjMX3V7B8ODsu/5VYbb0jgNju9/F1iieKRv
	i9m5+t3ds+cZyTvFGgkVSjEY7Iyr8VKuP/sy+8nyP6J2Npm3ZoSntMrz8RYJ1flu19v39Y+a
	241VOlnuhtubVpT7W0mbrz9yd9qGdfYGpr/zhc2FyzRe2WmwSL39/MW/RadFwpWr6z5nySol
	luKMREMt5qLiRACcDuHGnwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd1z228FGvSdNbWY+vAJm8WBPzsY
	Lb5d6WCyuLxrDpvF4RUHmCxO/ulltDjdzWpxccUXJou5vxtZLeZMf8fkwOWx4PMVdo+ds+6y
	e2xa1cnmcefaHjaPeScDPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxqwHB9gKLnBVLGnew9rA2MDZxcjJISFgIvH33xNmCFtM4sK99WxdjFwcQgKL
	GCWOzdnFDpIQEmhjkjjyubSLkYODTcBI4tUxO5CwiICCxObeZ6wg9cwCbxklli69wQKSEBZw
	kHjcugisl0VAVWLG58tgNq+Aq8SBlXdYIZYpSLQuOwQW5xRwk+iafJ0JYperxMc97UwTGHkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOuWdSOxhXNlgcYhTgYFTi4ZU4fTNQiDWx
	rLgy9xCjBAezkgivOOutQCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB6aDvJJ4Q2MTc1Nj
	U0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgPNLyUEpHQeTZ7XOvOlZuXtp/
	X9Oby8rHXu5Tcalk8KzjvV/F511P2VATKzRdVe2VZON03V3yCSfyd836v1XYovC/8dO3WSWv
	L7K0xE9ttNjy+MkEq0X7RStWPgm6W1hzfKeg9ye3Y9/5A59Oet6y2Pnm5PKSrkexRvVMhxcG
	aEdzJbpFsfr2KbEUZyQaajEXFScCAGXkm/H9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function _regulator_do_set_voltage(), old_selector gets intialised only
if (_regulator_is_enabled(rdev) && rdev->desc->ops->set_voltage_time_sel &&
rdev->desc->ops->get_voltage_sel)) is true.

Before calling set_voltage_time_sel() we checks if (old_selector >= 0) and it
will true if it got intialised properly. so we don't need to check again
_regulator_is_enabled(rdev) && rdev->desc->ops->set_voltage_time_sel before
calling set_voltage_time_sel().

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/core.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6e6371c..15368f3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2439,9 +2439,8 @@ static int _regulator_do_set_voltage(struct regulator_dev *rdev,
 	}
 
 	/* Call set_voltage_time_sel if successfully obtained old_selector */
-	if (ret == 0 && !rdev->constraints->ramp_disable &&
-	    _regulator_is_enabled(rdev) && old_selector >= 0 &&
-	    old_selector != selector && rdev->desc->ops->set_voltage_time_sel) {
+	if (ret == 0 && !rdev->constraints->ramp_disable && old_selector >= 0
+		&& old_selector != selector) {
 
 		delay = rdev->desc->ops->set_voltage_time_sel(rdev,
 						old_selector, selector);
-- 
1.7.0.4

