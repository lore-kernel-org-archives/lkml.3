Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab3CZCZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:25:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9384 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3CZCZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:25:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Mar 2013 19:24:28 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Anton Vorontsov <cbou@mail.ru>
CC: David Woodhouse <dwmw2@infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [REPOST Patch v1 0/3] Add DT Binding for Power-Supply power-supplies property
Date: Mon, 25 Mar 2013 22:24:47 -0400
Message-ID: <1364264690-2124-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series defines a common way for devicetree initialized
power_supplies to define their relationships between chargers and
supplicants.

This series adds a supplied_from array to complement the supplied_to
array and to allow supplies to define the list of supplies which
supply them.

Then once this property is supported, we can use a new property for
devicetree to define the relationships between nodes, and read in this
property to generate the supplied_from list.

With this logic in place, all drivers need to do to add support for
this mechanism, is to store their device tree node in the power_supply
struct. They should also handle EPROBE_DEFER properly.

Changes since:
RFC v2:
 - Changed to official Patch set rather than RFC
 - defined supplied_from char ** array rather than complicated
   struct device_node related array

RFC v1:
 - Inverted the logic so that supplies (batteries) contain a list of
   the supplies (chargers) which supply them.

Rhyland Klein (3):
  power_supply: Define Binding for power-supplies
  power: power_supply: Add core support for supplied_from
  power: power_supply_core: Add support for supplied_from

 .../bindings/power_supply/power_supply.txt         |   23 +++
 drivers/power/power_supply_core.c                  |  187 ++++++++++++++++++--
 include/linux/power_supply.h                       |    6 +
 3 files changed, 203 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/power_supply.txt

-- 
1.7.9.5

