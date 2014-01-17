Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaAQAHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:07:50 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:55539 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAQAHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:07:48 -0500
Message-ID: <1389917384.5567.718.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target fixes for v3.13
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kmo@daterainc.com
Date: Thu, 16 Jan 2014 16:09:44 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Here are the outstanding target fixes for v3.13 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master 

This series addresses a specific >= v3.12 regression related to the
iscsi-target percpu_ida conversion that has been reported during stress
testing over the last weeks.

The regression involves percpu_ida_alloc() going into uninterruptible
sleep while waiting for outstanding tags to be freed, thus not accepting
signals to force an return once a connection reset event has occurred.  

This change allows the percpu_ida tag allocator to optionally use
interruptible sleep that iscsi-target expects, while still leaving the
functionality + interface for existing percpu_ida consumers unchanged.

Thank you,

--nab

Kent Overstreet (1):
  percpu_ida: Allow tag alloc interface to interruptible sleep

Nicholas Bellinger (2):
  iscsi-target: Fix connection reset hang with percpu_ida_alloc
  iscsi-target: Pre-allocate more tags to avoid ack starvation

 drivers/target/iscsi/iscsi_target_nego.c |    2 +-
 drivers/target/iscsi/iscsi_target_util.c |    8 ++++++--
 include/linux/percpu_ida.h               |   10 +++++++++-
 lib/percpu_ida.c                         |   15 ++++++++++-----
 4 files changed, 26 insertions(+), 9 deletions(-)

-- 
1.7.10.4

