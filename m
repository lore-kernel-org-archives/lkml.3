Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaLCHUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:20:05 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:59738 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLCHUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:20:01 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: lgirdwood@gmail.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <00c818d4850f980e32e9a198831dbf9a>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun Xu <jay.xu@rock-chips.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        sonnyrao@chromium.org, heiko@sntech.de
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, Jianqun Xu <jay.xu@rock-chips.com>
Subject: [PATCH v2 0/2] ASoC: rockchip: i2s: driver could output "i2s-clk-out" optionally
Date: Wed,  3 Dec 2014 15:18:36 +0800
Message-Id: <1417591118-18695-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock generate unit in rockchip SoCs could generate clock named "i2s-clk-out"
separate from clock named "i2s-hclk", which is for i2s controller.

Since there may not need the "i2s-clk-out" outside, we make it optional in
driver, that could be decided in dts by add "i2s-clk-out" or not.

Tested on devices based on rk3288 with max98090 codec.

Jianqun Xu (1):
  ASoC: dt-bindings: rockchip-i2s: add an optional property
    "i2s_clk_out"

Sonny Rao (1):
  ASoC: rockchip: i2s: add support for grabbing output clock to codec

 Documentation/devicetree/bindings/sound/rockchip-i2s.txt |  8 ++++++--
 sound/soc/rockchip/rockchip_i2s.c                        | 13 +++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

--
changes since v1:
- rework with patches commit message, reference to old commit message of the
same related files.
- generate patch again by apply sonny's patch
- fix blank line in driver, suggested by Heiko and Doug, so add my owner
singed-off-by

1.9.1


