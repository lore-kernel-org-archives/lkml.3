Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3CKCoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:44:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37170 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab3CKCmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:42:36 -0400
X-IronPort-AV: E=Sophos;i="4.84,820,1355068800"; 
   d="scan'208";a="6847255"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, mst@redhat.com, asias@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        pbonzini@redhat.com
Subject: [PATCH V4 0/5] virtio-scsi multiqueue
Date: Mon, 11 Mar 2013 10:43:57 +0800
Message-Id: <1362969842-9145-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.rc2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 10:41:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 10:41:22,
	Serialize complete at 2013/03/11 10:41:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements virtio-scsi queue steering, which gives
performance improvements of up to 50% (measured both with QEMU and
tcm_vhost backends).

This version rebased on Rusty's virtio ring rework patches.
We hope this can go into virtio-next together with the virtio ring
rework pathes.


V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)

V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2


It would probably be easier to get it in via Rusty's tree
because of the prerequisites.  James, can we get your Acked-by?

Paolo Bonzini (4):
  virtio-scsi: redo allocation of target data
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: push vq lock/unlock into virtscsi_vq_done
  virtio-scsi: introduce multiqueue support

Wanlong Gao (1):
  virtio-scsi: reset virtqueue affinity when doing cpu hotplug

 drivers/scsi/virtio_scsi.c | 364 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 291 insertions(+), 73 deletions(-)

-- 
1.8.2.rc2

