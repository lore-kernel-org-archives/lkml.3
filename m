Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbbAZQsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:48:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11381 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbbAZQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:48:26 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-d3-54c66f469713
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] net/9p: fix format string in p9_mount_tag_show()
Date: Mon, 26 Jan 2015 19:48:16 +0300
Message-id: <1422290896-25042-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7pu+cdCDHqWmlts+/WIzeLx63ks
	FnPOt7BYzJ21id3i8q45bBb3pt9mtTi2QMxi2++NzBYf/65ic+D02LLyJpPHzll32T2m3dvE
	5PHg0GYWj90LPjN59G1ZxejRu3Uhm8fnTXIBHFFcNimpOZllqUX6dglcGXubr7IUzGKvmNN+
	g7mBsZGti5GTQ0LARGLKjd8sELaYxIV764HiXBxCAksZJSYc/8YM4fQxSRw5voMVpIpNQE/i
	36ztYN0iAgoSm3ufsYIUMQscZJLYt/UKO0hCWMBR4vyVvUwgNouAqkTT/bdgcV4BN4mv8z8A
	NXAArZOTuPAxfgIj9wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIWH1ZQfj4mNWhxgF
	OBiVeHgnTDwaIsSaWFZcmXuIUYKDWUmEVzr3WIgQb0piZVVqUX58UWlOavEhRiYOTqkGxpo4
	Dbu9fk8qQrZHvgmzWShgu86pLsXP9lWnbr6AguuU/B9/kiTT1s9bvy2KMdeeazPPY5NDFvwL
	/y25tId7m88cmd2rDfPPO66I8zcTbUm/cOr6ouMJq9/uOum25MutK4/mPrzA0smyRHLGg4vh
	bDF2+xiEnPJDGhTeyVp/ajc4c7eKddUpfSWW4oxEQy3mouJEAL1EVY8JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using "%s" for non-NULL terminated string is quite
dangerous, since this causes reading out of bounds.
chan->tag is non-NULL terminated, so precision
must be specified for printing it.

Fixes: 86c8437383ac ("net/9p: Add sysfs mount_tag file for virtio 9P device")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 net/9p/trans_virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index daa749c..f0d5f90 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -504,7 +504,8 @@ static ssize_t p9_mount_tag_show(struct device *dev,
 	vdev = dev_to_virtio(dev);
 	chan = vdev->priv;
 
-	return snprintf(buf, chan->tag_len + 1, "%s", chan->tag);
+	return snprintf(buf, chan->tag_len + 1, "%.*s",
+			chan->tag_len, chan->tag);
 }
 
 static DEVICE_ATTR(mount_tag, 0444, p9_mount_tag_show, NULL);
-- 
2.2.2

