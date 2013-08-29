Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3H2B6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:58:52 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42463 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3H2B6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:58:46 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: James.Bottomley@HansenPartnership.com
Cc: joern@logfs.org, vaughan.cao@oracle.com, dgilbert@interlog.com,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/4][SCSI] sg: fix race condition in sg_open
Date: Thu, 29 Aug 2013 10:00:35 +0800
Message-Id: <1377741639-3693-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377685578.2005.50.camel@dabdike>
References: <1377685578.2005.50.camel@dabdike>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race when open sg with O_EXCL flag. Also a race may happen between
sg_open and sg_remove.

Changes from v6:
 * [1/4] remove double if.
 * [3/4] fix via IS_ERR
Changes from v5:
 Patches based on v3.11-rc7 and passed sg_tst_excl test.
 * [1/4] * remove unused variables - res,sdp.
	 * fix insane code dealing with sg_add_sfp.
 * [2/4] resolve conflict with v3.11-rc7. 
 * [3/4] remove sem_out label.
 * [4/4] add sdp definition.

Changes from v4:
 * [3/4] use ERR_PTR series instead of adding another parameter in sg_add_sfp
 * [4/4] fix conflict for cherry-pick from v3.

Changes from v3:
 * release o_sem in sg_release(), not in sg_remove_sfp().
 * not set exclude with sfd_lock held.

Vaughan Cao (4):
  sg: use rwsem to solve race during exclusive open
  sg: no need sg_open_exclusive_lock
  sg: checking sdp->detached isn't protected when open
  sg: push file descriptor list locking down to per-device locking

 drivers/scsi/sg.c | 176 +++++++++++++++++++++++++-----------------------------
 1 file changed, 81 insertions(+), 95 deletions(-)

-- 
1.8.3.1

