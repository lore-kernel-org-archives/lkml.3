Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3H1KGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:06:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42027 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3H1KGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:06:21 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: James.Bottomley@HansenPartnership.com
Cc: joern@logfs.org, vaughan.cao@oracle.com, dgilbert@interlog.com,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/4][SCSI] sg: fix race condition in sg_open
Date: Wed, 28 Aug 2013 18:07:48 +0800
Message-Id: <1377684472-7815-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377662419.2005.12.camel@dabdike>
References: <1377662419.2005.12.camel@dabdike>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race when open sg with O_EXCL flag. Also a race may happen between
sg_open and sg_remove.

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

 drivers/scsi/sg.c | 173 +++++++++++++++++++++++++-----------------------------
 1 file changed, 80 insertions(+), 93 deletions(-)

-- 
1.8.3.1

