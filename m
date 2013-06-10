Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3FJV0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:26:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2780 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3FJV0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:26:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 10 Jun 2013 14:26:36 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, Stephen Warren <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 0/4] Fix and start using supplied_from logic
Date: Mon, 10 Jun 2013 17:26:38 -0400
Message-ID: <1370899602-22123-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series first fixes a refcount issue with the dt nodes
that was introduced with the supplied_from patch series. We add
a call to of_node_put to decrement the refcount for each node we get
from calling of_parse_phandle.

After that, this series enables using the supplied_from automatic
population from dt by passing in the dt nodes for the sbs battery
driver and the tps65090-charger driver.

Finally, the last patch creates this link for the tegra114-dalmore
board.

Rhyland Klein (4):
  power_supply: Add of_node_put to fix refcount
  power: sbs-battery: Add dt to power_supply struct
  power: tps65090-charger: Add dt node to power_supply
  arm: tegra: Add power-supplies link between battery and charger

 arch/arm/boot/dts/tegra114-dalmore.dts |    3 ++-
 drivers/power/power_supply_core.c      |    4 ++++
 drivers/power/sbs-battery.c            |    1 +
 drivers/power/tps65090-charger.c       |    1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

-- 
1.7.9.5

