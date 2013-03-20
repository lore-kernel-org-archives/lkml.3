Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3CTHA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 03:00:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50697 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3CTHA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 03:00:26 -0400
X-IronPort-AV: E=Sophos;i="4.84,876,1355068800"; 
   d="scan'208";a="6908322"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com, JBottomley@parallels.com,
        venkateshs@google.com, pbonzini@redhat.com, gaowanlong@cn.fujitsu.com
Subject: [PATCH V6 0/5] virtio-scsi multiqueue
Date: Wed, 20 Mar 2013 15:01:19 +0800
Message-Id: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.rc2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 14:58:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 14:58:54,
	Serialize complete at 2013/03/20 14:58:54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements virtio-scsi queue steering, which gives
performance improvements of up to 50% (measured both with QEMU and
tcm_vhost backends).

This version rebased on Rusty's virtio ring rework patches, which
has already gone into virtio-next today.
We hope this can go into virtio-next together with the virtio ring
rework pathes.

V6: rework "redo allocation of target data" (James)
    fix comments (Venkatesh)
    rebase to virtio-next

V5: improving the grammar of 1/5 (Paolo)
    move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)

V4: rebase on virtio ring rework patches (rusty's pending-rebases branch)

V3 and be found http://marc.info/?l=linux-virtualization&m=136067440717154&w=2


It would probably be easier to get it in via Rusty's tree
because of the prerequisites.  James, can we get your Acked-by?


Paolo Bonzini (3):
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: push vq lock/unlock into virtscsi_vq_done
  virtio-scsi: introduce multiqueue support

Wanlong Gao (2):
  virtio-scsi: redo allocation of target data
  virtio-scsi: reset virtqueue affinity when doing cpu hotplug

 drivers/scsi/virtio_scsi.c | 387 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 309 insertions(+), 78 deletions(-)

-- 
1.8.2.rc2

