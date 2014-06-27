Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaF0Qqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:46:55 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:59601 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaF0Qqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:46:53 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2014 12:46:53 EDT
From: Fredrik Noring <fredrik.noring@autoliv.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9A=
Date: Fri, 27 Jun 2014 16:16:57 +0000
Message-ID: <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
 <20140626140115.GQ32514@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
 <20140626151424.GT32514@n2100.arm.linux.org.uk>
 <20140627112151.GF32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140627112151.GF32514@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.136]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1017-20782.006
x-tm-as-result: No--42.736400-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

> On Thu, Jun 26, 2014 at 04:14:24PM +0100, Russell King - ARM Linux wrote:
> > That's a similar workload to the one which is mentioned in the
> > previous report.  I've just set a similar transfer going, but this
> > will be a 16GB file.
> 
> I've run this transfer several times, but so far I've unable to reproduce the
> issue here.

Many thanks for testing this. We attempted to bisect, but unfortunately the
result was not conclusive. One reason might be that the config had to be
updated during the process, and so we did not end up with the exact same
configuration (things like e.g. IMX_SDMA in DMA_ENGINE etc.). Some runs
deadlocked without any visible Oops or printout. Some versions did not have
an entirely working console configuration.

Please find below a trace that appeared once with 3.16-rc2. Perhaps it is of
some interest?

(We also had memtester run for days on the i.MX6 hardware, without issues.)

All the best,
Fredrik

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 dev_watchdog+0x270/0x27c()
NETDEV WATCHDOG: eth0 (fec): transmit queue 0 timed out
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc2 #19
Backtrace: 
[<80012390>] (dump_backtrace) from [<8001266c>] (show_stack+0x18/0x1c)
 r6:00000108 r5:00000000 r4:8064e29c r3:00000000
[<80012654>] (show_stack) from [<8049791c>] (dump_stack+0x8c/0x9c)
[<80497890>] (dump_stack) from [<80024f4c>] (warn_slowpath_common+0x74/0x90)
 r5:00000009 r4:80631d70
[<80024ed8>] (warn_slowpath_common) from [<80024fa0>] (warn_slowpath_fmt+0x38/0x40)
 r8:806320c0 r7:9d85a254 r6:9d879000 r5:9d85a000 r4:00000000
[<80024f6c>] (warn_slowpath_fmt) from [<803b8ff0>] (dev_watchdog+0x270/0x27c)
 r3:9d85a000 r2:805c4790
[<803b8d80>] (dev_watchdog) from [<8002f280>] (call_timer_fn+0x6c/0xe4)
 r10:80630008 r9:9d85a000 r8:803b8d80 r7:00000100 r6:80630000 r5:00000001
 r4:80631dd8
[<8002f214>] (call_timer_fn) from [<8002fec8>] (run_timer_softirq+0x1d4/0x254)
 r10:803b8d80 r9:806320c0 r8:9d85a000 r7:00000000 r6:80631e28 r5:80667040
 r4:9d85a284
[<8002fcf4>] (run_timer_softirq) from [<8002945c>] (__do_softirq+0x17c/0x30c)
 r10:00000001 r9:80632080 r8:40000001 r7:80630000 r6:00000100 r5:80632084
 r4:00000020
[<800292e0>] (__do_softirq) from [<80029920>] (irq_exit+0xd0/0x114)
 r10:80630000 r9:80665f19 r8:00000001 r7:f4000100 r6:00000000 r5:80630008
 r4:80630000
[<80029850>] (irq_exit) from [<8000f348>] (handle_IRQ+0x4c/0x98)
 r5:0000001d r4:8062ce44
[<8000f2fc>] (handle_IRQ) from [<80008614>] (gic_handle_irq+0x34/0x64)
 r6:80631f20 r5:80638a40 r4:f400010c r3:000000a0
[<800085e0>] (gic_handle_irq) from [<800131c4>] (__irq_svc+0x44/0x58)
Exception stack(0x80631f20 to 0x80631f68)
1f20: 00000001 00000001 00000000 8063b6f0 8063852c 806384d8 80665f19 804a0040
1f40: 00000001 80665f19 80630000 80631f74 00000000 80631f68 800614b8 8000f6a8
1f60: 200f0013 ffffffff
 r7:80631f54 r6:ffffffff r5:200f0013 r4:8000f6a8
[<8000f67c>] (arch_cpu_idle) from [<8005cbf8>] (cpu_startup_entry+0x10c/0x164)
[<8005caec>] (cpu_startup_entry) from [<80492b68>] (rest_init+0xc8/0xd8)
 r7:80625028 r3:00000000
[<80492aa0>] (rest_init) from [<805f6c5c>] (start_kernel+0x39c/0x3a8)
 r5:00000001 r4:806385d0
[<805f68c0>] (start_kernel) from [<10008074>] (0x10008074)
---[ end trace a7b7109ab2d04e11 ]---
***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

