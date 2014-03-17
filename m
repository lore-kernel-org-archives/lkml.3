Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaCQF6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:58:17 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:63808 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaCQFzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:55:32 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: [RFCv2 1/7] virtio-scsi.h: Add virtio_scsi_cmd_req_pi header definition
Date: Mon, 17 Mar 2014 05:32:55 +0000
Message-Id: <1395034381-656-2-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1395034381-656-1-git-send-email-nab@daterainc.com>
References: <1395034381-656-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a virtio_scsi_cmd_req_pi header as recommened by
Paolo that contains do_pi_niov + di_pi_niov elements used for
signaling when protection information buffers are expected to
preceed the data buffers.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/virtio_scsi.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
index 4195b97..4dc5998 100644
--- a/include/linux/virtio_scsi.h
+++ b/include/linux/virtio_scsi.h
@@ -35,11 +35,23 @@ struct virtio_scsi_cmd_req {
 	u8 lun[8];		/* Logical Unit Number */
 	u64 tag;		/* Command identifier */
 	u8 task_attr;		/* Task attribute */
-	u8 prio;
+	u8 prio;		/* SAM command priority field */
 	u8 crn;
 	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
 } __packed;
 
+/* SCSI command request, followed by protection information */
+struct virtio_scsi_cmd_req_pi {
+	u8 lun[8];		/* Logical Unit Number */
+	u64 tag;		/* Command identifier */
+	u8 task_attr;		/* Task attribute */
+	u8 prio;		/* SAM command priority field */
+	u8 crn;
+	u16 do_pi_niov;		/* DataOUT PI Number of iovecs */
+	u16 di_pi_niov;		/* DataIN PI Number of iovecs */
+	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
+} __packed;
+
 /* Response, followed by sense data and data-in */
 struct virtio_scsi_cmd_resp {
 	u32 sense_len;		/* Sense data length */
-- 
1.7.2.5

