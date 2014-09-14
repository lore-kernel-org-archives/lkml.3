Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaINTU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 15:20:56 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39174 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaINTUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 15:20:53 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 0/5] regulator: add support for syr82x to fan53555
Date: Sun, 14 Sep 2014 21:23:00 +0200
Message-Id: <1410722585-13393-1-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silergy SYR827 and SYR828 regulators use the completely same i2c interface
as the fan53555 regulators - only with different voltage ranges.
They are used in a some Rockchip rk3288 board designs around an act8846.

Therefore first add devicetree support for the fan53555 in general and
then support for the Silgery variants.

Tested on a rk3288 based Netxeon R89 board as cpu voltage regulator.


Heiko Stuebner (5):
  regulator: fan53555: enable vin supply
  regulator: fan53555: set regulator name from constraints name
  dt-bindings: add devicetree bindings for Fairchild FAN53555 regulators
  regulator: fan53555: add devicetree support
  regulator: fan53555: add support for Silergy SYR82x regulators

 .../devicetree/bindings/regulator/fan53555.txt     |  25 ++++
 .../devicetree/bindings/vendor-prefixes.txt        |   2 +
 drivers/regulator/fan53555.c                       | 161 +++++++++++++++++++--
 3 files changed, 174 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/fan53555.txt

-- 
2.0.1

