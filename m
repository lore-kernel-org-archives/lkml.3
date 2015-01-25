Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbbAYCMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 21:12:38 -0500
Received: from regular1.263xmail.com ([211.150.99.139]:58983 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbbAYCMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 21:12:35 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 107.152.154.13
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <c1b14687991262efda5bae8769394149>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <wxt@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>, Caesar Wang <wxt@rock-chips.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 0/1] thermal: rockchip: make temperature reporting much more accurate
Date: Sun, 25 Jan 2015 10:11:10 +0800
Message-Id: <1422151871-14347-1-git-send-email-wxt@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is merged on chromiumos/third_party/kernel.
https://chromium-review.googlesource.com/#/c/239190/

Tested on veyron boards.


Changes in v6:
It's not really need,so delete the follows:
else if (code == TSADCV2_DATA_MASK)

Changes in v5:
Fixed some style.

Changes in v4:
"return -EAGAIN" instead of "return rk_tsadcv2_code_to_temp(code)"

Changes in v3:
Suggested-by Daniel Kurtz,
the check doesn't reject "code == 0xfff"
Fixed in rk_tsadcv2_code_to_temp(u32 code)

Changes in v2:
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Caesar Wang (1):
  thermal: rockchip: make temperature reporting much more accurate

 drivers/thermal/rockchip_thermal.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

-- 
1.9.1


