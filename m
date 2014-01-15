Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaAOQ15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:27:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbaAOQ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:27:53 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org
Subject: [RFC PATCH v3 0/2] hung_task: Display every hung task warning
Date: Wed, 15 Jan 2014 16:27:09 +0000
Message-Id: <1389803231-16092-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

When khungtaskd detects hung tasks, it prints out
backtraces from a number of those tasks. Sometimes
the information on why things are stuck is hidden
in those backtraces. Limiting the number of
backtraces being printed out can result in the user
not seeing the information necessary to debug the
issue. This patch introduces an option to print an
unlimited number of backtraces when khungtaskd
detects hung tasks.

While ULONG_MAX is practically "inf", this patch
takes it one step further.  Note: The maximum is
now 2^31-1 (INT_MAX) which should hopefully be
sufficient.

Rebased against v3.13-rc8.

Aaron Tomlin (2):
  sysctl: Make neg_one a standard constraint
  hung_task: Display every hung task warning

 include/linux/sched/sysctl.h | 2 +-
 kernel/hung_task.c           | 6 ++++--
 kernel/sysctl.c              | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

-- 
1.8.4.2

