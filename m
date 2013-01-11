Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3AKIP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:15:58 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55014 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AKIP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:15:57 -0500
Message-ID: <50EFCA29.8020801@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 16:15:37 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011108-7014-0000-0000-0000027267A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is trying to simplify the select_task_rq_fair() with
schedule balance map.

After get rid of the complex code and reorganize the logical, pgbench show
the improvement.

	Prev:
		| db_size | clients |  tps  |
		+---------+---------+-------+
		| 22 MB   |       1 |  4437 |
		| 22 MB   |      16 | 51351 |
		| 22 MB   |      32 | 49959 |
		| 7484 MB |       1 |  4078 |
		| 7484 MB |      16 | 44681 |
		| 7484 MB |      32 | 42463 |
		| 15 GB   |       1 |  3992 |
		| 15 GB   |      16 | 44107 |
		| 15 GB   |      32 | 41797 |

	Post:
		| db_size | clients |  tps  |
		+---------+---------+-------+
		| 22 MB   |       1 | 11053 |		+149.11%
		| 22 MB   |      16 | 55671 |		+8.41%
		| 22 MB   |      32 | 52596 |		+5.28%
		| 7483 MB |       1 |  8180 |		+100.59%
		| 7483 MB |      16 | 48392 |		+8.31%
		| 7483 MB |      32 | 44185 |		+0.18%
		| 15 GB   |       1 |  8127 |		+103.58%
		| 15 GB   |      16 | 48156 |		+9.18%
		| 15 GB   |      32 | 43387 |		+3.8%

Please check the patch for more details about schedule balance map, they
currently based on linux-next 3.7.0-rc6, will rebase them to tip tree in
follow version.

Comments are very welcomed.

Test with:
	12 cpu X86 server and linux-next 3.7.0-rc6.

Michael Wang (2):
	[PATCH 1/2] sched: schedule balance map foundation
	[PATCH 2/2] sched: simplify select_task_rq_fair() with schedule balance map

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 core.c  |   61 +++++++++++++++++++++++++++++
 fair.c  |  133 +++++++++++++++++++++++++++++++++-------------------------------
 sched.h |   28 +++++++++++++
 3 files changed, 159 insertions(+), 63 deletions(-)

