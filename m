Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3GQPcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:32:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27451 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3GQPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:32:24 -0400
From: Vaughan Cao <vaughan.cao@oracle.com>
To: joern@logfs.org
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaughan.cao@oracle.com
Subject: [PATCH v4 0/4] [SCSI] sg: fix race condition in sg_open
Date: Wed, 17 Jul 2013 23:34:02 +0800
Message-Id: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20130715203730.GA21804@logfs.org>
References: <20130715203730.GA21804@logfs.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race when open sg with O_EXCL flag. Also a race may happen between
sg_open and sg_remove.

Changes from v3:
 * release o_sem in sg_release(), not in sg_remove_sfp().
 * not set exclude with sfd_lock held.

Vaughan Cao (4):
  [SCSI] sg: use rwsem to solve race during exclusive open
  [SCSI] sg: no need sg_open_exclusive_lock
  [SCSI] sg: checking sdp->detached isn't protected when open
  [SCSI] sg: push file descriptor list locking down to per-device
    locking

 drivers/scsi/sg.c | 186 ++++++++++++++++++++++++++----------------------------
 1 file changed, 88 insertions(+), 98 deletions(-)

-- 
1.7.11.7

