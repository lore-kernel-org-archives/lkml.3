Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaANXmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:42:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaANXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:42:40 -0500
From: atomlin@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, oleg@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org
Subject: [RFC PATCH v2 0/2] hung_task: Display every hung task warning
Date: Tue, 14 Jan 2014 23:41:56 +0000
Message-Id: <1389742918-32598-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

The khungtaskd thread limits how many hung task warnings it displays
at a time, when a timeout occurs. This patch allows that limit to be
set to "unlimited", by setting hung_task_warnings to -1, which will
cause khungtaskd to display information about all hung tasks.

While ULONG_MAX is practically "inf", this patch takes it one step
further. Note: The maximum is now 2^31-1 (INT_MAX) which should
hopefully be sufficient.

Rebased against v3.13-rc8.

Aaron Tomlin (2):
  sysctl: Make neg_one a standard constraint
  hung_task: Display every hung task warning

 include/linux/sched/sysctl.h | 2 +-
 kernel/hung_task.c           | 9 +++++----
 kernel/sysctl.c              | 6 ++++--
 3 files changed, 10 insertions(+), 7 deletions(-)

-- 
1.8.4.2

