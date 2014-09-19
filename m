Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbaISWlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:41:07 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:40280 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaISWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:41:05 -0400
Message-ID: <1411166462.23258.36.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target fixes for v3.17-rc6
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 19 Sep 2014 15:41:02 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the target pending fixes for v3.17-rc6.  Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Included are Sagi's long overdue fixes related to iser-target shutdown,
along with a couple of fixes from Sebastian related to ALUA Referrals
changes that when in during the v3.14 time-frame.

Also included are a few iscsi-target fixes, most recently of which where
found during Joern's Coverity scanning of target code.

Thanks,

--nab

Joern Engel (1):
  iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Nicholas Bellinger (2):
  iscsi-target: Ignore ICF_GOT_LAST_DATAOUT during Data-Out ITT lookup
  iscsi-target: Fix memory corruption in
    iscsit_logout_post_handler_diffcid

Sagi Grimberg (4):
  Target/iser: Get isert_conn reference once got to connected_handler
  Target/iser: Don't put isert_conn inside disconnected handler
  Target/iser: Avoid calling rdma_disconnect twice
  Target/iser: Fix initiator_depth and responder_resources

Sebastian Herbszt (2):
  target: Fix user data segment multiplier in spc_emulate_evpd_b3()
  target: Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE

 drivers/infiniband/ulp/isert/ib_isert.c        |   20 +++++++++++---------
 drivers/target/iscsi/iscsi_target.c            |    4 +++-
 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c       |    2 ++
 drivers/target/target_core_configfs.c          |    2 +-
 drivers/target/target_core_spc.c               |    2 +-
 6 files changed, 19 insertions(+), 13 deletions(-)

