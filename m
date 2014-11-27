Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaK0Mab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbaK0Ma3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:30:29 -0500
Date: Thu, 27 Nov 2014 14:30:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: [PATCH v5 02/45] mic_virtio: robust feature array size calculation
Message-ID: <1417091078-24611-3-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mic reads sizeof(vdev->features) bits from device, but in fact it stores
bits in local features variable. use sizeof(features) to make code
robust against future changes extending sizeof(vdev->features).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/misc/mic/card/mic_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 0acd564..2a6bc3f 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -76,8 +76,7 @@ static u32 mic_get_features(struct virtio_device *vdev)
 	u8 __iomem *in_features = mic_vq_features(desc);
 	int feature_len = ioread8(&desc->feature_len);
 
-	bits = min_t(unsigned, feature_len,
-		sizeof(vdev->features)) * 8;
+	bits = min_t(unsigned, feature_len, sizeof(features)) * 8;
 	for (i = 0; i < bits; i++)
 		if (ioread8(&in_features[i / 8]) & (BIT(i % 8)))
 			features |= BIT(i);
-- 
MST

