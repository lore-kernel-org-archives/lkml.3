Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab3CZAHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:07:43 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:41476 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab3CZAHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:41 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com
Subject: [PATCHSET wq/for-3.10] workqueue: replace pwq_lock with wq->mutex
Date: Mon, 25 Mar 2013 17:07:23 -0700
Message-Id: <1364256449-11401-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset renames wq->flush_mutex to wq->mutex and expands it to
protect most fields which are specific to each workqueue instance.
This simplifies the locking and makes it easier to understand.  The
mutex was already half there with multiple pool_workqueues support for
unbound workqueues anyway.

The patchese in this series are reshuffled / slightly updated versions
of the relevant patches in Lai's "workqueue: cleanups and better
locking for recent changes" patchset [1].  It contains the following
six patches.  The descriptions are mostly rewritten.

 0001-workqueue-rename-wq_mutex-to-wq_pool_mutex.patch
 0002-workqueue-rename-wq-flush_mutex-to-wq-mutex.patch
 0003-workqueue-protect-wq-nr_drainers-and-flags-with-wq-m.patch
 0004-workqueue-protect-wq-pwqs-and-iteration-with-wq-mute.patch
 0005-workqueue-protect-wq-saved_max_active-with-wq-mutex.patch
 0006-workqueue-remove-pwq_lock-which-is-no-longer-used.patch

0001 is 0007 in the original set.  s/wqs_mutex/wq_pool_mutex/
0002 is 0008.
0003 is 0009.
0004 is 0011.
0005 is 0012.
0006 is 0013.

These patches have been applied to wq/for-3.10.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10

So, I changes things a bit but nothing fundamental.  Other than some
renaming and reshuffling, these patches do exact the same things as
your original versions.  With these applied, your and my changes
shouldn't collide too much, so let's base everything on top of this.

Thanks.

diffstat follows.

 kernel/workqueue.c |  225 ++++++++++++++++++++++++-----------------------------
 1 file changed, 105 insertions(+), 120 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1459923
