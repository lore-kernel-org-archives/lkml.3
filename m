Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaEKTVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:21:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaEKTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.14 15/83] tools/virtio: add a missing )
Date: Sun, 11 May 2014 21:19:16 +0200
Message-Id: <20140511191909.167081167@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

commit be40d5ccab34d579512d932fc1c6cfaffe9d1551 upstream.

Fixes the following build failure:

 cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
   -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD
   -U_FORTIFY_SOURCE   -c -o virtio_test.o virtio_test.c
 virtio_test.c: In function ‘run_test’:
 virtio_test.c:176:7: error: expected ‘)’ before ‘r’
         r = -1;
         ^

Fixes: 53c18c9906441 (virtio_test: verify if virtqueue_kick() succeeded)
Cc: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/virtio/virtio_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -172,7 +172,7 @@ static void run_test(struct vdev_info *d
 							 GFP_ATOMIC);
 				if (likely(r == 0)) {
 					++started;
-					if (unlikely(!virtqueue_kick(vq->vq))
+					if (unlikely(!virtqueue_kick(vq->vq)))
 						r = -1;
 				}
 			} else


