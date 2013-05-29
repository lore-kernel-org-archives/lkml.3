Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3E2FZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:25:24 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43353 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3E2FZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:25:23 -0400
Message-ID: <51A5913A.5030302@gmail.com>
Date: Wed, 29 May 2013 13:25:14 +0800
From: jgq516@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
Subject: ftrace calltrace when boot through kexec
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I reboot a preempt_rt 3.4 kernel with cortex a15 tc2 board thru 
kexec, I got below calltrace appeared:

------------[ cut here ]------------
WARNING: at kernel/trace/ftrace.c:1584 ftrace_bug+0x1e0/0x224()
Modules linked in:
[<c0017e14>] (unwind_backtrace+0x0/0x104) from [<c062a468>] 
(dump_stack+0x20/0x24)
[<c062a468>] (dump_stack+0x20/0x24) from [<c00265a4>] 
(warn_slowpath_common+0x64/0x74)
[<c00265a4>] (warn_slowpath_common+0x64/0x74) from [<c00265e0>] 
(warn_slowpath_null+0x2c/0x34)
[<c00265e0>] (warn_slowpath_null+0x2c/0x34) from [<c00bf70c>] 
(ftrace_bug+0x1e0/0x224)
[<c00bf70c>] (ftrace_bug+0x1e0/0x224) from [<c00c03b4>] 
(ftrace_process_locs+0x880/0x930)
[<c00c03b4>] (ftrace_process_locs+0x880/0x930) from [<c082d018>] 
(ftrace_init+0xb4/0x194)
[<c082d018>] (ftrace_init+0xb4/0x194) from [<c081e8c4>] 
(start_kernel+0x338/0x348)
[<c081e8c4>] (start_kernel+0x338/0x348) from [<80008054>] (0x80008054)
---[ end trace af5b256dd27bb7ab ]---
ftrace failed to modify [<c0022b88>] platform_cpu_kill+0x10/0x1c
  actual: 00:40:bd:e8

Add notrace before platform_cpu_kill can workaround this calltrace, but 
it is weird that this problem can't
reproduce in another cortex-a9 (xilinx-zynq) board, could someone give 
some hints about this? Thanks.

Regards,
Xiao


