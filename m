Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaBXWNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:13:39 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33230 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaBXWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:13:36 -0500
Date: Mon, 24 Feb 2014 14:13:32 -0800
From: Venkatesh Srinivas <venkateshs@google.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com, nab@linux-iscsi.org
Subject: [PATCH] vhost/scsi: Check LUN structure byte 0 is set to 1, per spec
Message-ID: <20140224221332.GA32725@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtio spec requires byte 0 of the virtio-scsi LUN structure
to be '1'.

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
---
  drivers/vhost/scsi.c | 6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 0a025b8..e48d4a6 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1001,6 +1001,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
  			break;
  		}
  
+		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
+		if (unlikely(v_req.lun[0] != 1)) {
+			vhost_scsi_send_bad_target(vs, vq, head, out);
+			continue;
+		}
+
  		/* Extract the tpgt */
  		target = v_req.lun[1];
  		tpg = ACCESS_ONCE(vs_tpg[target]);
-- 
1.8.5.3
