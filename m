Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3DPLAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:00:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59017 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3DPLAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:00:22 -0400
Date: Tue, 16 Apr 2013 19:00:10 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130416110009.GA2664@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041611-5806-0000-0000-000020BF070A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

On a power7 system, we have installed 3.9-rc7 and crash 6.1.6. If I run
something like "make -j 64" to compile linux kernel from source, sooner
or latter, oom-killer will be triggered. Before that, when I trying to
analyse the live system with crash, some processes' %MEM and RSS looks
too big:

========================================

GNU gdb (GDB) 7.3.1
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "powerpc64-unknown-linux-gnu"...

crash: read error: kernel virtual address: c00000000074ee38  type: "cpu_possible_mask"

crash: this kernel may be configured with CONFIG_STRICT_DEVMEM, which
       renders /dev/mem unusable as a live memory source.

crash: trying /proc/kcore as an alternative to /dev/mem

      KERNEL: /boot/vmlinux-3.9.0-rc7
    DUMPFILE: /proc/kcore
        CPUS: 80
        DATE: Tue Apr 16 05:51:11 2013
      UPTIME: 00:44:42             
LOAD AVERAGE: 0.15, 0.53, 3.43
       TASKS: 876
    NODENAME: riblp3.upt.austin.ibm.com
     RELEASE: 3.9.0-rc7
     VERSION: #1 SMP Tue Apr 16 03:14:32 CDT 2013
     MACHINE: ppc64  (unknown Mhz)
      MEMORY: 4 GB
         PID: 9086
     COMMAND: "crash"
        TASK: c0000000c3640000  [THREAD_INFO: c0000000d7900000]
         CPU: 52
       STATE: TASK_RUNNING (ACTIVE)

crash> ps -u rpc.idmapd           
   PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
   1823      1   1  c0000000a66c0000  IN  281474976710656.0    5312 18014398509480192  rpc.idmapd
crash> 

========================================

I'd like to ask if this a problem of the kernel or crash. 

Thanks in advance.

