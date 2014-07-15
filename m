Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbaGOKcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:32:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55501 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758082AbaGOKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:32:28 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] wm5110 Interrupt Updates
Date: Tue, 15 Jul 2014 11:21:44 +0100
Message-Id: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newer versions of the wm5110 have made fairly
substancial changes to the interrupts, adding in many
new interrupts and moving some existing ones. These patches
update the register redefinitions and regmap hookup for
these. Full support is provided for both the old IP and the
new.

Thanks,
Charles

Charles Keepax (6):
  mfd: wm5110: Remove non-existant interrupts
  mfd: wm5110: Add in the output done interrupts
  mfd: arizona: Rename thermal shutdown interrupt
  mfd: wm5110: Add new interrupt register definitions
  mfd: arizona: Add missing handling for ISRC3 under/overclocked
  mfd: arizona: Only free the CTRLIF_ERR IRQ if we requested it

 drivers/mfd/arizona-core.c            |    4 +
 drivers/mfd/arizona-irq.c             |   29 +-
 drivers/mfd/arizona.h                 |    1 +
 drivers/mfd/wm5102-tables.c           |    8 +-
 drivers/mfd/wm5110-tables.c           |  245 ++++++++++-
 drivers/mfd/wm8997-tables.c           |    8 +-
 include/linux/mfd/arizona/core.h      |   33 ++-
 include/linux/mfd/arizona/registers.h |  785 +++++++++++++++++++++++++++++++--
 sound/soc/codecs/arizona.c            |   10 +-
 9 files changed, 1048 insertions(+), 75 deletions(-)

-- 
1.7.2.5

