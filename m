Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab3GCOHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:07:42 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53060 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab3GCOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:07:40 -0400
MIME-Version: 1.0
Date: Wed, 3 Jul 2013 22:07:38 +0800
Message-ID: <CALZhoSRkgibGBspD2RDjm+LZU4sJHBFKbn5JCJardNHTFKcUFQ@mail.gmail.com>
Subject: task kworker/u:0 blocked for more than 120 seconds
From: Lei Wen <adrian.wenl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I recently find a strange issue over 3.4 kernel.
The scenario is doing the hotplug test over ARM platfrom, and when the
hotplugged
out cpu1 want to get back in again, seems it stuck at cpu_stop_cpu_callback.

The task backtrace is as below:
PID: 21749  TASK: d194b300  CPU: 0   COMMAND: "kworker/u:0"
 #0 [<c05d6ff0>] (__schedule) from [<c05d5604>]
 #1 [<c05d5604>] (schedule_timeout) from [<c05d6a34>]
 #2 [<c05d6a34>] (wait_for_common) from [<c01543c8>]
 #3 [<c01543c8>] (kthread_create_on_node) from [<c05cf524>]
 #4 [<c05cf524>] (cpu_stop_cpu_callback) from [<c0159664>]
 #5 [<c0159664>] (notifier_call_chain) from [<c0139a84>]
 #6 [<c0139a84>] (__cpu_notify) from [<c05cdda4>]
 #7 [<c05cdda4>] (_cpu_up) from [<c05cdeb0>]
 #8 [<c05cdeb0>] (cpu_up) from [<c05c3bf8>]
 #9 [<c05c3bf8>] (hotplug_timer) from [<c014fe24>]
#10 [<c014fe24>] (process_one_work) from [<c0150240>]
#11 [<c0150240>] (worker_thread) from [<c01541b4>]
#12 [<c01541b4>] (kthread) from [<c0113ed8>]

Since I have full memory dump, and could do further analysis, do you
have any idea
that what kind of info need to provide to get it root caused?

Thanks,
Lei
