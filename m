Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaCTOiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:38:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48623 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbaCTOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:38:07 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eddie.wai@broadcom.com,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/9] Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,NULL)
Date: Thu, 20 Mar 2014 20:07:10 +0530
Message-Id: <cover.1395324808.git.monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset uses following coccinelle script to replace
rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,NULL)

@@
expression E;
@@
- rcu_assign_pointer(
+ RCU_INIT_POINTER(
E, NULL)

Monam Agarwal (9):
  net/ethernet: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
    NULL) in drivers/net/ethernet/broadcom/bnx2.c
  net/ethernet: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
    NULL) in drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
  net: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
    NULL) in drivers/net/macvtap.c
  net: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
    NULL) in drivers/net/ppp/pptp.c
  net/wireless: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
    NULL) in drivers/net/wireless/ath/carl9170/main.c
  scsi: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,
    NULL) in drivers/scsi/libfc/fc_libfc.c
  target: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, 
       NULL) in drivers/target/tcm_fc/tfc_sess.c
  vhost: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,  
      NULL) in drivers/vhost/net.c
  vhost: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,  
      NULL) in drivers/vhost/test.c

 drivers/net/ethernet/broadcom/bnx2.c               |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    4 ++--
 drivers/net/macvtap.c                              |    8 ++++----
 drivers/net/ppp/pptp.c                             |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |   12 ++++++------
 drivers/scsi/libfc/fc_libfc.c                      |    4 ++--
 drivers/target/tcm_fc/tfc_sess.c                   |    2 +-
 drivers/vhost/net.c                                |    2 +-
 drivers/vhost/test.c                               |    2 +-
 9 files changed, 19 insertions(+), 19 deletions(-)

-- 
1.7.9.5

