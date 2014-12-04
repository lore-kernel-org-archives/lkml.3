Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaLDNA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:00:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:38653 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbaLDNAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:00:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="493541751"
From: Teodora Baluta <teodora.baluta@intel.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Teodora Baluta <teodora.baluta@intel.com>
Subject: [RFC PATCH 2/3] iio: core: change channel's storagebits/realbits to u32
Date: Thu,  4 Dec 2014 15:00:16 +0200
Message-Id: <1417698017-13835-3-git-send-email-teodora.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to fit a channel that describes a fingerprint scan the u8 range is
not enough. For example, a scan whose height is 384 pixels and whose
width is 144, for a bit depth of 8 bits per pixels, the total bits would
be 384 x 144 x 8 = 442368, well over the u8 maximum 255 value.

Fix that by changing the realbits and storagebits fields in the
iio_chan_spec struct to u32.

Signed-off-by: Teodora Baluta <teodora.baluta@intel.com>
---
 include/linux/iio/iio.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index e280cfe..e34e67c 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -232,8 +232,8 @@ struct iio_chan_spec {
 	int			scan_index;
 	struct {
 		char	sign;
-		u8	realbits;
-		u8	storagebits;
+		u32	realbits;
+		u32	storagebits;
 		u8	shift;
 		u8	repeat;
 		enum iio_endian endianness;
-- 
1.9.1

