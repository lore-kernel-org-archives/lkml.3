Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaJ0Pos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:44:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53768 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJ0PoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:44:24 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-44-544e685588fb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/4] regulator: max77693: Make regulator_desc array const
Date: Mon, 27 Oct 2014 16:44:12 +0100
Message-id: <1414424654-27277-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
References: <1414424654-27277-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xa7qhGX4hBo0PDCymPnzCZvH6haHF
	tysdTBaXd81hs7i44guTA6vHzll32T02repk8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	qbd3sRQ8Zq24veAjewPjV5YuRk4OCQETiR8/3zFB2GISF+6tZwOxhQSWMkrs/BgJYfcxSbQ0
	yoDYbALGEpuXLwGq4eIQEehhlHh/6SRYA7OAocTPd3/Yuxg5OIQFPCVaeuJAwiwCqhKbFz9h
	B7F5Bdwlpnz+DrVLTuLkscmsIDangIfEwgW7GSF2uUs83tbINoGRdwEjwypG0dTS5ILipPRc
	I73ixNzi0rx0veT83E2MkJD5uoNx6TGrQ4wCHIxKPLwTin1DhFgTy4orcw8xSnAwK4nwHkjz
	CxHiTUmsrEotyo8vKs1JLT7EyMTBKdXAyDdJ/vhzlT838op9LTS4n4sEzHie+Lxx1vy/UWGn
	p/M2Ge9cZs+22WLCfSbztzJP2zOOivutWmkT/DlfsbK9crXH/s9LfaxfRn4reJR+RPRhujif
	QVxp/OEtlQ26u1o3bOSzcHYuDhWc9UWx2qWulvue/P9XE4Mrl5qt1ZdLXn1pwr1vD/+tVGIp
	zkg01GIuKk4EAFpJ8ej3AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator_register() expects array of 'regulator_desc' to be const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index c67ff05fc1dd..177dd9d2ce67 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -139,7 +139,7 @@ static struct regulator_ops max77693_charger_ops = {
 	.enable_mask	= SAFEOUT_CTRL_ENSAFEOUT##_num##_MASK ,	\
 }
 
-static struct regulator_desc regulators[] = {
+static const struct regulator_desc regulators[] = {
 	regulator_desc_esafeout(1),
 	regulator_desc_esafeout(2),
 	{
-- 
1.9.1

