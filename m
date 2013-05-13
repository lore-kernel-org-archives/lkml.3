Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3EMRkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:40:03 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:50684 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3EMRkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:40:02 -0400
Message-ID: <51912567.6090507@lwfinger.net>
Date: Mon, 13 May 2013 12:39:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: V3.10-rc1 memory leak
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using v3.10-rc1-68-g2d3ec09, I am getting many instances of the following from 
kmemleak:

unreferenced object 0xffff8800b546dc30 (size 48):
   comm "systemd-udevd", pid 2181, jiffies 4294899141 (age 274.096s)
   hex dump (first 32 bytes):
     00 dc 46 b5 00 88 ff ff d0 ff 5b a0 ff ff ff ff  ..F.......[.....
     1c 3b 5b a0 ff ff ff ff 12 3a 5b a0 ff ff ff ff  .;[......:[.....
   backtrace:
     [<ffffffff81432e81>] kmemleak_alloc+0x21/0x50
     [<ffffffff81143c2b>] kmem_cache_alloc+0x11b/0x270
     [<ffffffff810e9ee0>] __trace_define_field+0x40/0xd0
     [<ffffffff810e9fc5>] trace_define_field+0x55/0x70
     [<ffffffffa05e6ba0>] 0xffffffffa05e6ba0
     [<ffffffff810ea735>] event_create_dir+0x2e5/0x480
     [<ffffffff810ea920>] __trace_add_new_event+0x50/0x80
     [<ffffffff810eacf9>] __add_event_to_tracers+0x69/0xc0
     [<ffffffff810eb4e1>] trace_module_notify+0x1e1/0x2f0
     [<ffffffff8106e8f5>] notifier_call_chain+0x55/0x110
     [<ffffffff8106eb27>] __blocking_notifier_call_chain+0x67/0xc0
     [<ffffffff8106eb91>] blocking_notifier_call_chain+0x11/0x20
     [<ffffffff810af792>] load_module+0x19e2/0x24b0
     [<ffffffff810b0317>] SyS_init_module+0xb7/0xe0
     [<ffffffff814499d2>] system_call_fastpath+0x16/0x1b
     [<ffffffffffffffff>] 0xffffffffffffffff

These appear to be real leaks, but I am not familiar with this section of the 
code, and they could be false indications.

This mail is sent to all authors of patches incorporated in 
kernel/trace/trace_events.c in 2013. Kernel 3.9 did not show this problem.

Thanks,

Larry
