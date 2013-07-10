Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3GJLAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:00:48 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63778 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3GJLAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:00:46 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/2] virtio tools: strip bad include-path from Makefile
Date: Wed, 10 Jul 2013 16:26:59 +0530
Message-Id: <1373453820-22517-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
References: <1373453820-22517-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CFLAGS contains a mysterious "-I ../../usr/include", but no such path
exists in the linux tree.  The line was originally introduced in
4e53f78e (tools/virtio: virtio_test tool, 2010-11-29), but no such path
existed in the tree even then.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/virtio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index 3187c62..53623c6 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -3,7 +3,7 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
+CFLAGS += -g -O2 -Wall -I. -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
-- 
1.8.3.2.736.g869de25

