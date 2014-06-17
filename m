Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbaFQR2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:28:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56369 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444AbaFQR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:28:44 -0400
From: Jack Miller <millerjo@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com, miltonm@us.ibm.com,
        anton@au1.ibm.com
Subject: [RESEND] shm: shm exit scalability fixes 
Date: Tue, 17 Jun 2014 12:27:44 -0500
Message-Id: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061717-3532-0000-0000-000002892168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ RESEND note: Adding relevant CCs, fixed a couple of typos in commit message,
patches unchanged. Original intro follows. ]

All -

This is small set of patches our team has had kicking around for a few versions
internally that fixes tasks getting hung on shm_exit when there are many
threads hammering it at once.

Anton wrote a simple test to cause the issue:

http://ozlabs.org/~anton/junkcode/bust_shm_exit.c

Before applying this patchset, this test code will cause either hanging
tracebacks or pthread out of memory errors.

After this patchset, it will still produce output like:

root@somehost:~# ./bust_shm_exit 1024 160
...
INFO: rcu_sched detected stalls on CPUs/tasks: {} (detected by 116, t=2111
jiffies, g=241, c=240, q=7113)
INFO: Stall ended before state dump start
...
But the task will continue to run along happily, so we consider this an
improvement over hanging, even if it's a bit noisy.

I didn't author these patches, but I'd be happy to take any feedback and
address any issues.

- Jack

