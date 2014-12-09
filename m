Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaLINwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:52:03 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41315 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbaLINwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:52:00 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, broonie@kernel.org
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        devicetree@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Zhang Qing <zhangqing@rock-chips.com>
Subject: [PATCH 0/2] add the dvs support for rk808
Date: Tue,  9 Dec 2014 21:51:44 +0800
Message-Id: <1418133106-5634-1-git-send-email-zyw@rock-chips.com>
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


Chris Zhong (2):
  regulator: rk808: add dvs support
  mfd: dt-bindings: add the description about dvs gpio for rk808

 Documentation/devicetree/bindings/mfd/rk808.txt |  10 +-
 drivers/regulator/rk808-regulator.c             | 192 ++++++++++++++++++++++--
 2 files changed, 189 insertions(+), 13 deletions(-)

-- 
1.9.1

