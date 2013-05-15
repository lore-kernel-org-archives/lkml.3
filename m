Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab3EONIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:08:22 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64830 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3EONIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:08:21 -0400
MIME-Version: 1.0
Date: Wed, 15 May 2013 16:08:20 +0300
Message-ID: <CAKt3ReLZqGS3DiG_+T+N0YDzte9pLpP8kVVoX_98vTU9tPV3pQ@mail.gmail.com>
Subject: Function call interrupts (CAL) high values in 3.9.2 kernel
From: "Darius D." <darius.ski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading to 3.9.2 (from 3.2.1) we have noticed million sized
spikes in Function call interrupts (CAL) graphics in Munin monitoring.

After some investigation we have found that it is caused by completely
borked numbers in /proc/interrupts

for example current output is:
CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6
      CPU7       CPU8       CPU9       CPU10      CPU11      CPU12
 CPU13      CPU14      CPU15      C6      CPU17      CPU18      CPU19
    CPU20      CPU21      CPU22      CPU23
CAL: 4294967272    5513065         56    5567608         21    5513363
        50    5583946         42    5431365         32    5681459
  100    2613904         95    2494755         95    2554234
122    2434635         74    2472960         63    2504140   Function
call interrupts

As you can see CPU1 output has really crazy value (FFFFFFE8), but we
have seen some other values on other cpus as well. It changes suddenly
from valid values, to nearly FFFFFFFF and then might return back after
some time.
There are no spikes in cpu usage, no interrupts, context switches,
just /proc/interrupts is wrong. it went stright from ~50 to FFFFFFE8
in one step.

System is dual Xeon X5650 NUMA box. ( kinda only interesting options
are THP with defrag off and that new Numa memory placement aware
scheduler is off ).

Anyone got any clue why it is happening?

Best regards,

Darius.
