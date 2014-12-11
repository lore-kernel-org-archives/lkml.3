Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbaLKDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 22:16:56 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63068 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbaLKDQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 22:16:54 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, broonie@kernel.org
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Zhang Qing <zhangqing@rock-chips.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 0/2] add the dvs support for rk808
Date: Thu, 11 Dec 2014 11:16:40 +0800
Message-Id: <1418267802-13159-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk808 has a dvs function, there are 3 pins for dvs, dvs1 & dvs2 & dvsok.
Normally, the voltage of DCDC1/DCDC2 are controlled by BUCKn_ON_VSEL, when
we pull dvs1/dvs2 pin to active, they would be controlled by BUCKn_DVS_VSEL.
And the dvsok pin is used to indicate whether regulating has been completed.
When dvs1/dvs2 pin change, dvsok would be pull down, and it would be pull up
once the regulating is complete.

Changes in v2:
- increase description about dvs pins
- modify the multiline commenting

Chris Zhong (2):
  mfd: dt-bindings: add the description about dvs gpio for rk808
  regulator: rk808: add dvs support

 Documentation/devicetree/bindings/mfd/rk808.txt |  13 +-
 drivers/regulator/rk808-regulator.c             | 192 ++++++++++++++++++++++--
 2 files changed, 192 insertions(+), 13 deletions(-)

-- 
1.9.1

