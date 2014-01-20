Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaATRe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:34:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaATRe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:34:56 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org, atomlin@redhat.com
Subject: [RFC PATCH v4 0/2] hung_task: Display every hung task warning
Date: Mon, 20 Jan 2014 17:34:11 +0000
Message-Id: <1390239253-24030-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

When khungtaskd detects hung tasks, it prints out backtraces from
a number of those tasks. Limiting the number of backtraces being
printed out can result in the user not seeing the information
necessary to debug the issue. The hung_task_warnings sysctl
controls this feature.

This patch makes it possible for hung_task_warnings to accept a
special value to print an unlimited number of backtraces when
khungtaskd detects hung tasks.

The special value is -1. To use this value it is necessary to
change types from ulong to int.

Rebased against v3.13-rc8.

Changes since v3:
 - Simplify the commit message (Rik van Riel and David Rientjes)
 - Document hung_task_* sysctl parameters (David Rientjes)

Aaron Tomlin (2):
  sysctl: Make neg_one a standard constraint
  hung_task: Display every hung task warning

 Documentation/sysctl/kernel.txt | 42 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sched/sysctl.h    |  2 +-
 kernel/hung_task.c              |  6 ++++--
 kernel/sysctl.c                 |  6 ++++--
 4 files changed, 51 insertions(+), 5 deletions(-)

-- 
1.8.4.2

