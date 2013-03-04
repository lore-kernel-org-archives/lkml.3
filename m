Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab3CDETJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:19:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60792 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755466Ab3CDDmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:39 -0500
Message-Id: <20130304033721.138542062@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:25 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 138/153] vhost: fix length for cross region descriptor
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit bd97120fc3d1a11f3124c7c9ba1d91f51829eb85 upstream.

If a single descriptor crosses a region, the
second chunk length should be decremented
by size translated so far, instead it includes
the full descriptor length.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/vhost/vhost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1073,7 +1073,7 @@ static int translate_desc(struct vhost_d
 		}
 		_iov = iov + ret;
 		size = reg->memory_size - addr + reg->guest_phys_addr;
-		_iov->iov_len = min((u64)len, size);
+		_iov->iov_len = min((u64)len - s, size);
 		_iov->iov_base = (void __user *)(unsigned long)
 			(reg->userspace_addr + addr - reg->guest_phys_addr);
 		s += size;


