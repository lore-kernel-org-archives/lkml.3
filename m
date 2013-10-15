Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470Ab3JOTXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:23:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41382 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759432Ab3JOTXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:23:53 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, lee.jones@linaro.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 0/3 v2] Add regulator supply alias
Date: Tue, 15 Oct 2013 20:14:19 +0100
Message-Id: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patchs adds feature to allow an alias to
be created for regulator supply lookup. This aliases will
perform the lookup on a different device from that requested
by the end user. We also add features into the MFD core to
easily map supplies from a child device to the main MFD
device.

The main use case for this is when an MFD device is
registered as a single node through device tree. It allows
frameworks dealing with the individual child drivers to
locate their regulators on the main MFD device, without any
prior knowledge of its existance. An implementation is given
using the arizona driver which has its supplies registered
this way through device tree.

This patch series is based on Mark's regulator for-next
branch.

One thing I would be interested on improving is
the function names they get very long. For example
devm_regulator_register_bulk_supply_alias, I would wonder
if swapping the register for an add and perhaps swapping
supply_alias for just alias would be acceptable? This would
give us devm_regulator_get_alias() which is a bit more
reasonable in terms of length although perhaps slightly less
idiomatic.

Changes from version 1:
 - Added bulk and devm versions for all the calls
 - Registration of the aliases is added to the MFD framework
   rather than done in the driver probe

Charles Keepax (3):
  regulator: core: Add ability to create a lookup alias for supply
  mfd: Allow mapping regulator supplies to MFD device from children
  mfd: arizona: Specify supply mappings for Arizona CODECs

 arch/arm/mach-s3c64xx/mach-crag6410.c |   12 ---
 drivers/mfd/arizona-core.c            |   32 ++++++-
 drivers/mfd/mfd-core.c                |   22 ++++-
 drivers/regulator/core.c              |  170 +++++++++++++++++++++++++++++++++
 drivers/regulator/devres.c            |  163 +++++++++++++++++++++++++++++++
 include/linux/mfd/core.h              |    6 +
 include/linux/regulator/consumer.h    |   79 +++++++++++++++
 7 files changed, 464 insertions(+), 20 deletions(-)

-- 
1.7.2.5

