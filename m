Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaF0BM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 21:12:28 -0400
Received: from [141.146.126.69] ([141.146.126.69]:28410 "EHLO
	aserp1040.oracle.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaF0BM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 21:12:26 -0400
Message-ID: <53ACC4D1.7090407@oracle.com>
Date: Thu, 26 Jun 2014 21:11:45 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: hung task without any output
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity I've recently observed a situation with has started
occurring rather frequently.

I have my configuration set to do a trigger_all_cpu_backtrace() before executing
panic(), and that's exactly what happens in some cases.

The new thing which I started seeing is the following:

[ 4806.833452] Kernel panic - not syncing: hung_task: blocked tasks
[ 4806.834701] CPU: 26 PID: 3252 Comm: khungtaskd Not tainted 3.16.0-rc2-next-20140626-sasha-00023-g9256882-dirty #732
[ 4806.837672]  00000000003ffcda ffff880bb2d6bd38 ffffffffb1529940 0000000000000001
[ 4806.839784]  ffffffffb26fecef ffff880bb2d6bdb8 ffffffffb151cb0f 0000000000000001
[ 4806.840057]  0000000000000008 ffff880bb2d6bdc8 ffff880bb2d6bd68 0000000000000001
[ 4806.840057] Call Trace:
[ 4806.840057]  [<ffffffffb1529940>] dump_stack+0x4f/0x7c
[ 4806.840057]  [<ffffffffb151cb0f>] panic+0xd2/0x217
[ 4806.840057]  [<ffffffffae24273f>] watchdog+0x43f/0x620
[ 4806.840057]  [<ffffffffae242389>] ? watchdog+0x89/0x620
[ 4806.840057]  [<ffffffffae242300>] ? reset_hung_task_detector+0x20/0x20
[ 4806.840057]  [<ffffffffae196718>] kthread+0x108/0x110
[ 4806.840057]  [<ffffffffae196610>] ? kthread_create_on_node+0x260/0x260
[ 4806.840057]  [<ffffffffb15774bc>] ret_from_fork+0x7c/0xb0
[ 4806.840057]  [<ffffffffae196610>] ? kthread_create_on_node+0x260/0x260
[ 4806.840057] Dumping ftrace buffer:
[ 4806.840057]    (ftrace buffer empty)
[ 4806.840057] Kernel Offset: 0x2d000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Without anything else to accompany it.


Thanks,
Sasha
