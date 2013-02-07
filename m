Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3BGTJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:09:22 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:65414 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3BGTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:09:21 -0500
From: Rob Herring <robherring2@gmail.com>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/4] Improve CLKSRC_OF matching
Date: Thu,  7 Feb 2013 13:09:00 -0600
Message-Id: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In the recently added support for OF based clocksource init, a device node
will be matched twice. We can fix this by passing the device node to the
init functions and removing the match functions within the init functions.

This is based on arm-soc for-next branch and commit "of: fix incorrect
return value of of_find_matching_node_and_match()" in my DT for-next
branch.

Rob

Rob Herring (4):
  clocksource: pass DT node pointer to init functions
  clocksource: bcm2835: use the device_node pointer passed to init
  clocksource: vt8500: use the device_node pointer passed to init
  clocksource: tegra20: use the device_node pointer passed to init

 drivers/clocksource/bcm2835_timer.c |   12 +-----
 drivers/clocksource/clksrc-of.c     |    4 +-
 drivers/clocksource/tegra20_timer.c |   70 ++++++++++++++---------------------
 drivers/clocksource/vt8500_timer.c  |   14 +------
 4 files changed, 31 insertions(+), 69 deletions(-)

-- 
1.7.10.4

