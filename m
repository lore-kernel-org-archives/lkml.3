Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012Ab3DBLgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:36:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46553 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760158Ab3DBLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 04/16] extcon: arizona: Don't pulse MICBIAS for HPDET identification
Date: Tue,  2 Apr 2013 12:32:36 +0100
Message-Id: <1364902368-1123-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to do this as HPDET identification will cause MICBIAS to
be powered down again.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index e233962..95748d3 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -693,8 +693,6 @@ static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info)
 
 	info->hpdet_active = true;
 
-	arizona_extcon_pulse_micbias(info);
-
 	arizona_extcon_do_magic(info, 0x4000);
 
 	ret = regmap_update_bits(arizona->regmap,
-- 
1.7.10.4

