Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab3HMQdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:33:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab3HMQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:51 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=JIRhoisSancA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GA9nCqaG_WIA:10 a=20KFwNOVAAAA:8 a=yMhMjlubAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=0cRFCE-MzT_khLpehsgA:9 a=jEp0ucaQiEUA:10 a=-AOE9ft50oIA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=u5mEQeM0wOFTezRi:21 a=ph9TMAlYN4lwFIry:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155834.826743057@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [71/88] drivers: hv: switch to use mb() instead of smp_mb()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0071-drivers-hv-switch-to-use-mb-instead-of-smp_mb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 35848f68b07df3f917cb13fc3c134718669f569b ]

Even if guest were compiled without SMP support, it could not assume that host
wasn't. So switch to use mb() instead of smp_mb() to force memory barriers for
UP guest.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/hv/ring_buffer.c |    2 +-
 drivers/hv/vmbus_drv.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 7233c88..14aa6fe 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -454,7 +454,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index */
 	/*is updated */
-	smp_mb();
+	mb();
 
 	/* Update the read index */
 	hv_set_next_read_location(inring_info, next_read_location);
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4748086..db5fc10 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -466,7 +466,7 @@ static void vmbus_on_msg_dpc(unsigned long data)
 		 * will not deliver any more messages since there is
 		 * no empty slot
 		 */
-		smp_mb();
+		mb();
 
 		if (msg->header.message_flags.msg_pending) {
 			/*
-- 
1.7.10.4


