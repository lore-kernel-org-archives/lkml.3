Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3JSAUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:20:48 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58839 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3JSAUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:20:47 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] wireless: rt2800lib: Fix typo on checking
Date: Fri, 18 Oct 2013 21:20:42 -0300
Message-Id: <1382142042-4463-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rt2800_config_channel_rf53xx function the member default_power1 is checked
for bound limit, but default_power2 is used instead.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 88ce656..1c2ce93 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2650,7 +2650,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,

 	if (rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
-		if (info->default_power1 > POWER_BOUND)
+		if (info->default_power2 > POWER_BOUND)
 			rt2x00_set_field8(&rfcsr, RFCSR50_TX, POWER_BOUND);
 		else
 			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
--
1.7.10.4

