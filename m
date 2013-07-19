Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274Ab3GSRRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:17:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45253 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3GSRRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:17:51 -0400
Message-ID: <51E974A9.3050608@zytor.com>
Date: Fri, 19 Jul 2013 10:17:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.10.0 i386 uniprocessor panic
References: <20130718061347.17426.qmail@science.horizon.com>
In-Reply-To: <20130718061347.17426.qmail@science.horizon.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 11:13 PM, George Spelvin wrote:
> I ressurected an old Athlon XP box for fun, and was stress-testing it
> with mprime.  (It had been stable before retirement.)  After 34 hours
> of successful torture test (suggesting a stable memory syatem), I found
> this on the screen (hand-transcribed, top scrolled off):
> 
> h_rpcgss oid_registry exportfs nfs_acl nfs lockd sunrpc loop fuse sil164 nouveau video mxm_wmi wmi ttm fbcon font bitblit softcursor drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbfillrect serio_raw cfbimgblt hid_generic processor fan thermal thermal_sys button
> CPU: 0 PID: 3567 Comm: mprime Not tainted 3.10.0 #4
> Hardware name:    /FN41 , BIOS 6.00 PG 08/23/2004
> task: f31849f0 ti: f3150000 task.ti: f3150000
> EIP: 0060:[<c143a091>] EFLAGS 00010286 CPU: 0
> EIP is at 0xc143a091
> EAX: c143a090 EBX: 00000100 ECX: f3150000 EDX: c143a090
> ESI: c143a090 EDI: c143a090 EBP: c143a090 ESP: f3151eec
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> CR0: 80050033 CR2: a090c143 CR3: 331c6000 CR4: 000007d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
> Stack:
>  c102437d b665a951 0000713f 8ae3556c 0000a66a f31849f0 00000002 c1439980
>  c143a080 c1024524 c143a090 c143a0a4 00000000 00000000 f3151f30 c143a190
>  c143a390 c143a080 e63938bc 00000001 f3150000 c1439844 00000100 c1020e8b
> Call Trace:
>  [<c102437d>] ? call_timer_fn.isra.37+0x16/0x6d
>  [<c1024524>] ? run_timer_softirq+0x150/0x165
>  [<c1020e8b>] ? __do_softirq+0x8b/0x135
>  [<c1020fe4>] ? irq_exit+0x3d/0x72
>  [<c10021f2>] ? do_IRQ+0x69/0x7c
>  [<c1088524>] ? SyS_write+0x59/0x6a
>  [<c10015ef>] ? math_state_restore+0x73/0xcd
>  [<c128192c>] ? common_interrupt+0x2c/0x31
> Code: 43 c1 68 a0 43 c1 68 a0 43 c1 70 a0 43 c1 70 a0 43 c1 78 a0 43 c1 78 a0 43 c1 00 00 00 00 00 02 20 00 88 a0 43 c1 88 a0 43 c1 90 <a0> 43 c1 90 a0 43 c1 98 a0 43 c1 98 a0 43 c1 a0 a0 43 c1 a0 a0
> EIP: [<c143a091>] 0xc143a091 SS:ESP 0068:f3151eec
> CR2: 00000000a090c143
> ---[ end trace 4009bf27ab8c3bf3 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> drm_kms_helper: panic occurred, switching back to text console
> 
> (The CR2 value looks particularly odd.)
> 

Indeed it does; it is a user space value, but it doesn't look like
either a normal user space value nor really as a trivially buggered-up
kernel pointer value, unless the 0xc143... at the bottom is the upper
half of a kernel pointer, in which case we probably obtained this value
from a corrupt, misaligned pointer.

	-hpa


