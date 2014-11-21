Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaKUFTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:19:50 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:48354 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKUFTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:19:48 -0500
Message-ID: <1416547137.27917.70.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target fixes for v3.18-rc6
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Nov 2014 21:18:57 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the target-pending fixes queued for v3.18-rc6. Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The highlights include:

  - target-core OOPs fix with tcm_qla2xxx + vxworks FC initiators + zero length
    SCSI commands having a transfer direction set. (Roland + Craig Watson)
  - vhost-scsi OOPs fix to explicitly prevent WWPN endpoint configfs group removal
    while qemu still has an active reference.  (Paolo + nab)
  - ib_srpt fix for RDMA hardware with lower srp_sq_size limits. (Bart)
  - Two ib_isert work-arounds for running on ocrdma hardware (Or + Sagi + Chris)
  - iscsi-target discovery portal typo + SPC-3 PR Preempt SA key matching fix (Steve)

Thank you,

--nab

Bart Van Assche (1):
  srp-target: Retry when QP creation fails with ENOMEM

Chris Moore (1):
  IB/isert: Adjust CQ size to HW limits

Nicholas Bellinger (1):
  vhost-scsi: Take configfs group dependency during
    VHOST_SCSI_SET_ENDPOINT

Or Gerlitz (1):
  ib_isert: Add max_send_sge=2 minimum for control PDU responses

Roland Dreier (1):
  target: Don't call TFO->write_pending if data_length == 0

Sagi Grimberg (1):
  iser-target: Handle DEVICE_REMOVAL event on network portal listener
    correctly

Steven Allen (2):
  iscsi-target: return the correct port in SendTargets
  target: return CONFLICT only when SA key unmatched

 drivers/infiniband/ulp/isert/ib_isert.c | 44 ++++++++++++++++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  8 ++++++
 drivers/target/iscsi/iscsi_target.c     |  2 +-
 drivers/target/target_core_pr.c         |  9 ++++---
 drivers/target/target_core_transport.c  |  2 +-
 drivers/vhost/scsi.c                    | 24 ++++++++++++++++++
 6 files changed, 69 insertions(+), 20 deletions(-)

