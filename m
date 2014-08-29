Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaH2IiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:38:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:17723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaH2IiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378564414"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org
Cc: srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, laurentiu.palcu@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] iio: accel: BMC150: add support for more Bosch chips
Date: Fri, 29 Aug 2014 11:38:05 +0300
Message-Id: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
 * fixed the sensitivity value: 75590 -> 76590
 * changed comments, commit messages and IDs to reflect that BMA250E and BMA222E
   are the chips supported (not BMA250/BMA222);

To ease reviewers' job (I should've done that from the very beginning, sorry), here's
where you cand find the registers table for each chip. It's easier to compare:

BMC150:  [1] - page 66
BMI055:  [2] - page 46
BMA250E: [3] - page 49
BMA222E: [4] - page 49
BMA280:  [5] - page 49
BMA255:  [6] - page 49

[1] http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS000-04.pdf
[2] http://ae-bst.resource.bosch.com/media/products/dokumente/bmi055/BST-BMI055-DS000-06.pdf
[3] http://ae-bst.resource.bosch.com/media/products/dokumente/bma250e/BST-BMA250E-DS004-05_published.pdf
[4] http://ae-bst.resource.bosch.com/media/products/dokumente/bma222e/BST-BMA222E-DS004-05_published.pdf
[5] http://ae-bst.resource.bosch.com/media/products/dokumente/bma280/BST-BMA280-DS000-11_published.pdf
[6] http://ae-bst.resource.bosch.com/media/products/dokumente/bma255/BST-BMA255-DS004-05_published.pdf

laurentiu

Laurentiu Palcu (3):
  iio: accel: BMC150: fix scale value for 16G
  iio: accel: BMC150: fix issues when CONFIG_PM_RUNTIME is not set
  iio: accel: BMC150: add support for other Bosch chips

 drivers/iio/accel/bmc150-accel.c | 236 ++++++++++++++++++++++++++++++---------
 1 file changed, 183 insertions(+), 53 deletions(-)

-- 
1.9.1

