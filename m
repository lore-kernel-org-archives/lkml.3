Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaH2Ijw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:39:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:17723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbaH2IiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378564442"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org
Cc: srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, laurentiu.palcu@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] iio: accel: BMC150: fix scale value for 16G
Date: Fri, 29 Aug 2014 11:38:06 +0300
Message-Id: <1409301488-22166-2-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com>
References: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to documentation ([1] - page 27), the range for 16G is
7.81mg/LSB. Converted to SI, this is:
    7.81 * 10^-3 * 9.80665 m/s^2 / LSB = 0.0765899365 m/s^2 / LSB

[1] http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS000-04.pdf

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/iio/accel/bmc150-accel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
index 23ae334..ccb6cf8 100644
--- a/drivers/iio/accel/bmc150-accel.c
+++ b/drivers/iio/accel/bmc150-accel.c
@@ -173,7 +173,7 @@ static const struct {
 } bmc150_accel_scale_table[] = { {9610, BMC150_ACCEL_DEF_RANGE_2G},
 				 {19122, BMC150_ACCEL_DEF_RANGE_4G},
 				 {38344, BMC150_ACCEL_DEF_RANGE_8G},
-				 {77057, BMC150_ACCEL_DEF_RANGE_16G} };
+				 {76590, BMC150_ACCEL_DEF_RANGE_16G} };
 
 static const struct {
 	int sleep_dur;
-- 
1.9.1

