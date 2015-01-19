Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbbASLvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:51:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:48059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbbASLvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:51:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,426,1418112000"; 
   d="scan'208";a="514247905"
From: Octavian Purdila <octavian.purdila@intel.com>
To: lee.jones@linaro.org
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 0/2] DLN2 fixes related to suspend/resume
Date: Mon, 19 Jan 2015 13:51:34 +0200
Message-Id: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Here is the 3rd version of the patch-set against for-mfd-next branch
with the Reviewed-by tags from Johan. Note that I dropped the two GPIO
patches as they were already merged by Linus W in the GPIO tree.

Thanks,
Tavi

Changes since v2:

 * Dropped the GPIO fixes from this series as they were merged in the
   GPIO tree

 * Removed a stray newline

 * Updated the resume / suspend patch commit with more information
   about which cases it fixes and which it does not

Changes since v1:

 * Fix an issue introduced by v1 where we can get a use after free in
   the error path of probe

 * Add start/stop RX URBs helpers

 * move the suspend/resume routines above the module device table

 * used GFP_NOIO in resume

Octavian Purdila (2):
  mfd: dln2: add start/stop RX URBs helpers
  mfd: dln2: add suspend/resume functionality

 drivers/mfd/dln2.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 10 deletions(-)

-- 
1.9.1

