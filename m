Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3EaQug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:50:36 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:58335 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3EaQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:50:30 -0400
Date: Fri, 31 May 2013 11:50:26 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: old version of trace-cmd broken on 3.10 kernel
Message-ID: <20130531165026.GC2910@sbohrermbp13-local.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is a big deal or not.  I've got an old version of
trace-cmd. It was built from git on 2012-09-12 but sadly I didn't
stash away the exact commit hash.  Anyway this version works fine on a
3.4 kernel but on a 3.10-rc3 kernel it no longer works.  I just pulled
the latest trace-cmd from git and it works fine on the 3.10 kernel so
maybe this isn't an issue, but I don't typically expect applications
to break with a kernel upgrade.

When I run the old version on 3.10.0-rc3 I get the following output:

$ sudo trace-cmd record -e sched:sched_switch -e sched:sched_wakeup sleep 1
/sys/kernel/debug/tracing/events/sched/sched_wakeup/filter
/sys/kernel/debug/tracing/events/sched/sched_switch/filter
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
trace-cmd: Interrupted system call
  recorder error in splice input
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 93
overrun: 0
commit overrun: 0
bytes: 5112
oldest event ts:  7013.613622
now ts:  7013.656459
dropped events: 0
read events: 607

CPU: 1
entries: 88
overrun: 0
commit overrun: 0
bytes: 4396
oldest event ts:  7013.638352
now ts:  7013.656515
dropped events: 0
read events: 960

CPU: 2
entries: 154
overrun: 0
commit overrun: 0
bytes: 7592
oldest event ts:  7013.583332
now ts:  7013.656572
dropped events: 0
read events: 1211

CPU: 3
entries: 150
overrun: 0
commit overrun: 0
bytes: 7324
oldest event ts:  7013.589348
now ts:  7013.656625
dropped events: 0
read events: 1303

CPU: 4
entries: 84
overrun: 0
commit overrun: 0
bytes: 5096
oldest event ts:  7013.621239
now ts:  7013.656677
dropped events: 0
read events: 1175

CPU: 5
entries: 146
overrun: 0
commit overrun: 0
bytes: 9016
oldest event ts:  7013.601549
now ts:  7013.656729
dropped events: 0
read events: 2204

CPU: 6
entries: 77
overrun: 0
commit overrun: 0
bytes: 4824
oldest event ts:  7013.651234
now ts:  7013.656781
dropped events: 0
read events: 2148

CPU: 7
entries: 109
overrun: 0
commit overrun: 0
bytes: 6600
oldest event ts:  7013.621326
now ts:  7013.656837
dropped events: 0
read events: 1672

CPU: 8
entries: 110
overrun: 0
commit overrun: 0
bytes: 6804
oldest event ts:  7013.603146
now ts:  7013.656891
dropped events: 0
read events: 2272

CPU: 9
entries: 142
overrun: 0
commit overrun: 0
bytes: 8496
oldest event ts:  7013.584943
now ts:  7013.656942
dropped events: 0
read events: 1521

CPU: 10
entries: 98
overrun: 0
commit overrun: 0
bytes: 6408
oldest event ts:  7013.617605
now ts:  7013.656995
dropped events: 0
read events: 1706

CPU: 11
entries: 293
overrun: 0
commit overrun: 0
bytes: 19208
oldest event ts:  7013.607094
now ts:  7013.657047
dropped events: 0
read events: 9236

CPU: 12
entries: 152
overrun: 0
commit overrun: 0
bytes: 7136
oldest event ts:  7013.582819
now ts:  7013.657099
dropped events: 0
read events: 1112

CPU: 13
entries: 86
overrun: 0
commit overrun: 0
bytes: 3928
oldest event ts:  7013.560591
now ts:  7013.657150
dropped events: 0
read events: 769

CPU: 14
entries: 85
overrun: 0
commit overrun: 0
bytes: 4076
oldest event ts:  7013.426020
now ts:  7013.657202
dropped events: 0
read events: 586

CPU: 15
entries: 211
overrun: 0
commit overrun: 0
bytes: 9568
oldest event ts:  7013.578705
now ts:  7013.657253
dropped events: 0
read events: 1578

CPU: 16
entries: 114
overrun: 0
commit overrun: 0
bytes: 7104
oldest event ts:  7013.626635
now ts:  7013.657304
dropped events: 0
read events: 3643

CPU: 17
entries: 63
overrun: 0
commit overrun: 0
bytes: 3972
oldest event ts:  7013.542660
now ts:  7013.657355
dropped events: 0
read events: 651

CPU: 18
entries: 87
overrun: 0
commit overrun: 0
bytes: 5732
oldest event ts:  7013.639776
now ts:  7013.657407
dropped events: 0
read events: 2901

CPU: 19
entries: 103
overrun: 0
commit overrun: 0
bytes: 6584
oldest event ts:  7013.638704
now ts:  7013.657458
dropped events: 0
read events: 3016

CPU: 20
entries: 103
overrun: 0
commit overrun: 0
bytes: 6404
oldest event ts:  7013.599359
now ts:  7013.657509
dropped events: 0
read events: 1297

CPU: 21
entries: 102
overrun: 0
commit overrun: 0
bytes: 6452
oldest event ts:  7013.576149
now ts:  7013.657566
dropped events: 0
read events: 384

CPU: 22
entries: 67
overrun: 0
commit overrun: 0
bytes: 4236
oldest event ts:  7013.641692
now ts:  7013.657619
dropped events: 0
read events: 799

CPU: 23
entries: 119
overrun: 0
commit overrun: 0
bytes: 7556
oldest event ts:  7013.616204
now ts:  7013.657670
dropped events: 0
read events: 2286

CPU0 data recorded at offset=0x2f7000
    32768 bytes in size
CPU1 data recorded at offset=0x2ff000
    49152 bytes in size
CPU2 data recorded at offset=0x30b000
    61440 bytes in size
CPU3 data recorded at offset=0x31a000
    65536 bytes in size
CPU4 data recorded at offset=0x32a000
    73728 bytes in size
CPU5 data recorded at offset=0x33c000
    135168 bytes in size
CPU6 data recorded at offset=0x35d000
    135168 bytes in size
CPU7 data recorded at offset=0x37e000
    102400 bytes in size
CPU8 data recorded at offset=0x397000
    143360 bytes in size
CPU9 data recorded at offset=0x3ba000
    90112 bytes in size
CPU10 data recorded at offset=0x3d0000
    110592 bytes in size
CPU11 data recorded at offset=0x3eb000
    602112 bytes in size
CPU12 data recorded at offset=0x47e000
    53248 bytes in size
CPU13 data recorded at offset=0x48b000
    36864 bytes in size
CPU14 data recorded at offset=0x494000
    28672 bytes in size
CPU15 data recorded at offset=0x49b000
    73728 bytes in size
CPU16 data recorded at offset=0x4ad000
    229376 bytes in size
CPU17 data recorded at offset=0x4e5000
    40960 bytes in size
CPU18 data recorded at offset=0x4ef000
    184320 bytes in size
CPU19 data recorded at offset=0x51c000
    192512 bytes in size
CPU20 data recorded at offset=0x54b000
    81920 bytes in size
CPU21 data recorded at offset=0x55f000
    24576 bytes in size
CPU22 data recorded at offset=0x565000
    49152 bytes in size
CPU23 data recorded at offset=0x571000
    143360 bytes in size

Every-other time I run it, it hangs after a few of the "recorder error
in splice input" messages and I have to Ctrl-C it, but otherwise the
output is essentially the same.  I'm fine with updating my trace-cmd
version but if this is a symptom of a bigger kernel regression I
figured I should post to the list.

--
Shawn
