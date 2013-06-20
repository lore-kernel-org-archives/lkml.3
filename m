Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422760Ab3FTTqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:46:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940Ab3FTTqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:46:22 -0400
Message-ID: <51C35C05.1070005@canonical.com>
Date: Thu, 20 Jun 2013 14:46:13 -0500
From: Dave Chiluk <chiluk@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Scheduler accounting inflated for io bound processes.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running the below testcase shows each process consuming 41-43% of it's
respective cpu while per core idle numbers show 63-65%, a disparity of
roughly 4-8%.  Is this a bug, known behaviour, or consequence of the
process being io bound?

1. run sudo taskset -c 0 netserver
2. run taskset -c 1 netperf -H localhost -l 3600 -t TCP_RR & (start
netperf with priority on cpu1)
3. run top, press 1 for multiple CPUs to be separated

The below output is the top output notice the cpu0 idle at 67% when the
processes claim 42% usage a roughly 9% discrepancy.

------------------------------------------------
top - 19:27:38 up  4:08,  2 users,  load average: 0.45, 0.19, 0.13
Tasks:  85 total,   2 running,  83 sleeping,   0 stopped,   0 zombie
%Cpu0  :  0.8 us, 15.4 sy,  0.0 ni, 66.7 id,  0.0 wa,  0.0 hi, 17.1 si,
 0.0 st
%Cpu1  :  0.8 us, 17.3 sy,  0.0 ni, 63.1 id,  0.0 wa,  0.0 hi, 18.8 si,
 0.0 st
KiB Mem:   4049180 total,   252952 used,  3796228 free,    23108 buffers
KiB Swap:        0 total,        0 used,        0 free,   132932 cached

  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND

 6150 root      20   0  9756  700  536 R  42.6  0.0   0:48.90 netserver

 6149 ubuntu    20   0 11848 1056  852 S  42.2  0.0   0:48.92 netperf
------------------------------------------------

The above testcase was run on 3.10-rc6.

So is this a bug or can someone explain to me why this isn't a bug?

The related ubuntu bug is
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1193073
