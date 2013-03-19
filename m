Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3CSJ7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:59:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1842 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab3CSJ5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:57:52 -0400
X-IronPort-AV: E=Sophos;i="4.84,871,1355068800"; 
   d="scan'208";a="6901520"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com, JBottomley@parallels.com,
        pbonzini@redhat.com, gaowanlong@cn.fujitsu.com
Subject: [PATCH V5 0/5] virtio-scsi multiqueue
Date: Tue, 19 Mar 2013 17:57:32 +0800
Message-Id: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.rc2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/19 17:55:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/19 17:55:11,
	Serialize complete at 2013/03/19 17:55:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements virtio-scsi queue steering, which gives
performance improvements of up to 50% (measured both with QEMU and
tcm_vhost backends).

This version rebased on Rusty's virtio ring rework patches.
We hope this can go into virtio-next together with the virtio ring
rework pathes.

V5: improving the grammar of 1/5 (Paolo)
    move the dropping of sg_elems to 'virtio-scsi: use virtqueue_add_sgs for command buffers'. (Asias)

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

 drivers/scsi/virtio_scsi.c | 359 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 290 insertions(+), 69 deletions(-)

-- 
1.8.2.rc2

