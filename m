Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaLNWFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:05:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:46115 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaLNWEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:04:44 -0500
Date: Mon, 15 Dec 2014 00:04:38 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 5/6] tools/virtio: add virtio 1.0 in virtio_test
Message-ID: <1418594542-22623-6-git-send-email-mst@redhat.com>
References: <1418594542-22623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418594542-22623-1-git-send-email-mst@redhat.com>
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/virtio_test.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 67873c3..e044589 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -228,6 +228,14 @@ const struct option longopts[] = {
 		.val = 'i',
 	},
 	{
+		.name = "virtio-1",
+		.val = '1',
+	},
+	{
+		.name = "no-virtio-1",
+		.val = '0',
+	},
+	{
 		.name = "delayed-interrupt",
 		.val = 'D',
 	},
@@ -244,6 +252,7 @@ static void help(void)
 	fprintf(stderr, "Usage: virtio_test [--help]"
 		" [--no-indirect]"
 		" [--no-event-idx]"
+		" [--no-virtio-1]"
 		" [--delayed-interrupt]"
 		"\n");
 }
@@ -252,7 +261,7 @@ int main(int argc, char **argv)
 {
 	struct vdev_info dev;
 	unsigned long long features = (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
-		(1ULL << VIRTIO_RING_F_EVENT_IDX);
+		(1ULL << VIRTIO_RING_F_EVENT_IDX) | (1ULL << VIRTIO_F_VERSION_1);
 	int o;
 	bool delayed = false;
 
@@ -273,6 +282,9 @@ int main(int argc, char **argv)
 		case 'i':
 			features &= ~(1ULL << VIRTIO_RING_F_INDIRECT_DESC);
 			break;
+		case '0':
+			features &= ~(1ULL << VIRTIO_F_VERSION_1);
+			break;
 		case 'D':
 			delayed = true;
 			break;
-- 
MST

