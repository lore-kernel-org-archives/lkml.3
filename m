Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3CATlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:41:09 -0500
Received: from hera.mpi-klsb.mpg.de ([139.19.1.49]:32940 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3CATlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:41:07 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 14:41:07 EST
Message-ID: <51310270.8060002@mpi-sws.org>
Date: Fri, 01 Mar 2013 20:33:04 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120419 Icedove/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Possible recursive locking on "tick_periodic()" and "do_timer()"
 because of "xtime_lock" in 3.7.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MPI-Local-Sender: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bellow you'll find a bug report for a possible bug involving recursive 
locking.

Thanks,
Pedro

----
[1.] One line summary of the problem:

Possible recursive locking on "tick_periodic()" and "do_timer()" because 
of "xtime_lock" in 3.7.9


[2.] Full description of the problem/report:

See [5] for the recursive locking error message.


[3.] Keywords (i.e., modules, networking, kernel):

Recursive locking, deadlock, timers


[4.] Kernel version (from /proc/version):
Linux version 3.7.9 (root@xxx) (gcc version 4.4.5 (Debian 4.4.5-8) )

[5.] Output of Oops.. message (if applicable) with symbolic information
resolved (see Documentation/oops-tracing.txt)

[  239.964148]
[  239.964148] =============================================
[  239.964148] [ INFO: possible recursive locking detected ]
[  239.964148] 3.7.9 #2 Not tainted
[  239.964148] ---------------------------------------------
[  239.964148] rt_sigaction01/2203 is trying to acquire lock:
[  239.964148]  (xtime_lock){-.-...}, at: [<c1074382>] 
tick_periodic+0x32/0x70
[  239.964148]
[  239.964148] but task is already holding lock:
[  239.964148]  (xtime_lock){-.-...}, at: [<c1074382>] 
tick_periodic+0x32/0x70
[  239.964148]
[  239.964148] other info that might help us debug this:
[  239.964148]  Possible unsafe locking scenario:
[  239.964148]
[  239.964148]        CPU0
[  239.964148]        ----
[  239.964148]   lock(xtime_lock);
[  239.964148]   lock(xtime_lock);
[  239.964148]
[  239.964148]  *** DEADLOCK ***
[  239.964148]
[  239.964148]  May be due to missing lock nesting notation
[  239.964148]
[  239.964148] 2 locks held by rt_sigaction01/2203:
[  239.964148]  #0:  (xtime_lock){-.-...}, at: [<c1074382>] 
tick_periodic+0x32/0x70
[  239.964148]  #1:  (&(&(&tk->lock)->lock)->rlock){-.-...}, at: 
[<c106e981>] do_timer+0x31/0x9c0
[  239.964148]
[  239.964148] stack backtrace:
[  239.964148] Pid: 2203, comm: rt_sigaction01 Not tainted 3.7.9 #2
[  239.964148] Call Trace:
[  239.964148]  [<c107916a>] __lock_acquire+0x5ba/0x1400
[  239.964148]  [<c107a014>] lock_acquire+0x64/0x80
[  239.964148]  [<c1074382>] ? tick_periodic+0x32/0x70
[  239.964148]  [<c171b9e3>] _raw_spin_lock+0x33/0x40
[  239.964148]  [<c1074382>] ? tick_periodic+0x32/0x70
[  239.964148]  [<c1074382>] tick_periodic+0x32/0x70
[  239.964148]  [<c10743d9>] tick_handle_periodic+0x19/0x80
[  239.964148]  [<c10214cf>] smp_apic_timer_interrupt+0x4f/0x90
[  239.964148]  [<c1275594>] ? trace_hardirqs_off_thunk+0xc/0x18
[  239.964148]  [<c171c6ae>] apic_timer_interrupt+0x32/0x38
[  239.964148]  [<c106ef33>] ? do_timer+0x5e3/0x9c0
[  239.964148]  [<c10743aa>] tick_periodic+0x5a/0x70
[  239.964148]  [<c10743d9>] tick_handle_periodic+0x19/0x80
[  239.964148]  [<c10214cf>] smp_apic_timer_interrupt+0x4f/0x90
[  239.964148]  [<c1275594>] ? trace_hardirqs_off_thunk+0xc/0x18
[  239.964148]  [<c171c6ae>] apic_timer_interrupt+0x32/0x38


[6.] A small shell script or example program which triggers the problem 
(if possible)
N/A


[7.] Environment
Running inside a (modified) QEMU virtual machine based on version 1.0.1.



