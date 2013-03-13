Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab3CMX61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58794 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab3CMX60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:26 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com
Subject: [PATCHSET wq/for-3.10] workqueue: misc cleanups
Date: Wed, 13 Mar 2013 16:58:12 -0700
Message-Id: <1363219098-16083-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains mostly cleanups and a fix for a bug in the new
unbound pools w/ attrs.

This patchset contains the following six patches.

 0001-workqueue-relocate-pwq_set_max_active.patch
 0002-workqueue-implement-and-use-pwq_adjust_max_active.patch
 0003-workqueue-fix-max_active-handling-in-init_and_link_p.patch
 0004-workqueue-update-comments-and-a-warning-message.patch
 0005-workqueue-rename-id-to-pi-in-for_each_each_pool.patch
 0006-workqueue-inline-trivial-wrappers.patch

0001-0002 clean up pwq->max_active handling.

0003 fixes a race condition around max_active handling for the new
unbound pools w/ attrs.

0004-0006 are cleanups which make no functional differences other than
inlining of some trivial wrappers.

This patch is on top of wq/for-3.10 e626761691 ("workqueue: implement
current_is_workqueue_rescuer()").

diffstat follows.  Thanks.

 include/linux/workqueue.h |  123 +++++++++++++++--
 kernel/workqueue.c        |  324 +++++++++++++++-------------------------------
 2 files changed, 218 insertions(+), 229 deletions(-)

--
tejun
