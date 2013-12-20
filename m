Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3LTHnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:43:53 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:52923 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3LTHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:43:51 -0500
From: Christian Riesch <christian.riesch@omicron.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Christian Riesch <christian.riesch@omicron.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Amul Kumar Saha <amul.saha@samsung.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH v2 0/2] mtd: Harmonize implementations of OTP write and _get_{fact,user}_prot_info
Date: Fri, 20 Dec 2013 08:36:31 +0100
Message-Id: <1387524993-3353-1-git-send-email-christian.riesch@omicron.at>
X-Mailer: git-send-email 1.7.9.5
X-Df-Sender: Y2hyaXN0aWFuQHJpZXNjaC5hdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In the discussion on my patchset for the OTP support for
drivers/mtd/chips/cfi_cmdset_0002.c [1-5], Artem requested two changes in the
current code of the OTP write functions and the _get_{fact,user}_prot_info
code.

These two patches are an attempt to make the requested changes.

The first patch adds a retlen parameter to the _get_fact_prot_info and
_get_user_prot_info functions and thus harmonizes the implementation
with those of the write and read functions.

The second patch fixes a problem that I earlier addressed in [1]. After
the discussion about this patch on the mtd mailing list, I think that the
correct behavior of the write function should be the one specified in [6]:
Try to write as many bytes as possible and return the number of bytes
that were written. If no data could be written due to lack of OTP memory,
return -ENOSPC.

Artem, would you please have a look at these patches? I would like to know
if I understood you correctly, or if I missed something here. Please note
that I cannot test these patches since I do not have the hardware. The
patches are compile tested only. If these patches are ok, I will also
respin the OTP support patches for cfi_cmdset_0002.

Changes for v2:
- Fixed buggy cfi_intelext_get_fact_prot_info

Thank you!

Best regards,
Christian

[1] http://patchwork.ozlabs.org/patch/239897/
[2] http://patchwork.ozlabs.org/patch/240010/
[3] http://patchwork.ozlabs.org/patch/240007/
[4] http://patchwork.ozlabs.org/patch/240008/
[5] http://patchwork.ozlabs.org/patch/240009/
[6] http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html

Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Amul Kumar Saha <amul.saha@samsung.com>
Cc: Brian Norris <computersforpeace@gmail.com>

Christian Riesch (2):
  mtd: Add a retlen parameter to _get_{fact,user}_prot_info
  mtd: Fix the behavior of otp write if there is not enough room for
    data

 drivers/mtd/chips/cfi_cmdset_0001.c |   44 +++++++++++++++++++----------------
 drivers/mtd/devices/mtd_dataflash.c |   20 +++++++---------
 drivers/mtd/mtdchar.c               |   18 ++++++++++----
 drivers/mtd/mtdcore.c               |   12 +++++-----
 drivers/mtd/mtdpart.c               |   14 ++++++-----
 drivers/mtd/onenand/onenand_base.c  |   40 ++++++++++++++++---------------
 include/linux/mtd/mtd.h             |   16 ++++++-------
 7 files changed, 89 insertions(+), 75 deletions(-)

-- 
1.7.9.5

