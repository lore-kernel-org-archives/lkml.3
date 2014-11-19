Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbaKSWvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:51:47 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:38585 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946AbaKSWvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:51:44 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Linus Walleij <linus.walleij@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Zhong <zyw@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Pinctrl fixes for rockchip
Date: Wed, 19 Nov 2014 14:51:31 -0800
Message-Id: <1416437493-25588-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix some pinctrl issues on rockchip.  The first
fixes a real issue where interrupts were being left on in
suspend/resume and waking the system up when they shouldn't.  The
second fixes purely theoretical problems but seems clean.

I've tested these patches more extensively on a non-mainline tree but
have done basic compile and boot testing on mainline.  I don't have
suspend/resume working so well on mainline yet, so I haven't tested
fully there.

Changes in v2:
- Spread out code (heiko)

Doug Anderson (2):
  pinctrl: rockchip: Handle wakeup pins
  pinctrl: rockchip: Fix enable/disable/mask/unmask

 drivers/pinctrl/pinctrl-rockchip.c | 57 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 3 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5

