Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaIPVbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:31:07 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36437 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaIPVbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:31:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/fsRoXJDxWTvP4LEzYYGWA
Date: Tue, 16 Sep 2014 14:30:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
Message-ID: <20140916213043.GB6672@atomide.com>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <20140912224324.GK18849@atomide.com>
 <5416D2A0.5020407@linutronix.de>
 <541833C0.5020106@linutronix.de>
 <20140916164858.GA1580@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140916164858.GA1580@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140916 09:49]:
> * Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140916 05:58]:
> > On 09/15/2014 01:50 PM, Sebastian Andrzej Siewior wrote:
> > > I changed the restore function the fix the am335x-evm + less "freeze".
> > > And now we have this. So let me search…
> > 
> > IER was 0 by accident. It fixed in TX path.
> > I pushed uart_v10_pre1 which should have it fixed aport from other
> > things…
> 
> Just verified that works for my off-idle test case thanks.
> 
> > I am going to address the review comments, to split the DMA callbacks
> > as requested and if nobody comes up with something fancy we will have a
> > v10 :)
> 
> OK

Found one more issue when booting on 2420 n8x0, maybe something to do
with runtime PM?

Regards,

Tony

[    4.770507] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[    4.777343] Modules linked in:
[    4.780487] CPU: 0 PID: 1 Comm: init Not tainted 3.17.0-rc5-00211-gc2182d0-dirty #1408
[    4.788482] task: c5842b80 ti: c5850000 task.ti: c5850000
[    4.793945] PC is at serial8250_start_tx+0x124/0x154
[    4.798980] LR is at uart_start+0x4c/0x5c
[    4.803039] pc : [<c03d7340>]    lr : [<c03d1ee4>]    psr: a0000093
[    4.803039] sp : c5851e10  ip : c5851e28  fp : c5851e24
[    4.814605] r10: 00000007  r9 : 00000000  r8 : c134d554
[    4.819885] r7 : c5cb7800  r6 : 20000013  r5 : c134d554  r4 : c134d554
[    4.826477] r3 : c134d690  r2 : 00000000  r1 : 00000001  r0 : c134d554
[    4.833068] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    4.840332] Control: 00c5387d  Table: 85cd8000  DAC: 00000015
[    4.846130] Process init (pid: 1, stack limit = 0xc5850248)
[    4.851776] Stack: (0xc5851e10 to 0xc5852000)
[    4.856201] 1e00:                                     c5cb7800 c134d554 c5851e44 c5851e28
[    4.864440] 1e20: c03d1ee4 c03d7228 c5842b80 00000000 c5b00408 c5cf3c07 c5851e7c c5851e48
[    4.872711] 1e40: c03d2da0 c03d1ea4 c5851e6c a0000013 c03d1fe0 c5cb7800 00000007 0000224c
[    4.880981] 1e60: c88cc2a0 00002250 c5cf3c00 c88ca000 c5851edc c5851e80 c03b9474 c03d2cd4
[    4.889251] 1e80: c5851e9c c5cb7ab4 c5cf3c00 c5cb793c c5a5ae00 c5850000 c0158e1c 00000000
[    4.897491] 1ea0: c5842b80 c007152c c5cb7ad4 c5cb7ad4 c5cb7800 0000e0cc 00000007 c5cb7800
[    4.905761] 1ec0: 00000000 c5850000 00000400 c5a5ae00 c5851f1c c5851ee0 c03b61c0 c03b92d0
[    4.914031] 1ee0: 00000007 00000007 c5cb18c0 c03b92c4 c0b19f20 00000000 00000007 0000e0cc
[    4.922271] 1f00: c5851f78 c5a5ae00 c5850000 0000e0cc c5851f44 c5851f20 c03b63c4 c03b60c0
[    4.930541] 1f20: c5851f78 c5a5ae00 00000007 0000e0cc c5851f78 00000007 c5851f74 c5851f48
[    4.938812] 1f40: c0168f38 c03b632c c0185718 c0185688 00000000 00000000 c5a5ae00 c5a5ae00
[    4.947052] 1f60: 00000007 0000e0cc c5851fa4 c5851f78 c0169380 c0168e90 00000000 00000000
[    4.955322] 1f80: 00000000 0000e0cc 00000001 00000004 c000f164 00000000 00000000 c5851fa8
[    4.963592] 1fa0: c000eee0 c0169340 00000000 0000e0cc 00000000 0000e0cc 00000007 00000000
[    4.971862] 1fc0: 00000000 0000e0cc 00000001 00000004 0000a24c 00017504 10000000 00000000
[    4.980102] 1fe0: bef5aa40 bef5aa30 0000a474 b6e801ec 60000010 00000000 ffffffff ffffffff
[    4.988372] [<c03d7340>] (serial8250_start_tx) from [<c03d1ee4>] (uart_start+0x4c/0x5c)
[    4.996490] [<c03d1ee4>] (uart_start) from [<c03d2da0>] (uart_write+0xd8/0x100)
[    5.003875] [<c03d2da0>] (uart_write) from [<c03b9474>] (n_tty_write+0x1b0/0x510)
[    5.011474] [<c03b9474>] (n_tty_write) from [<c03b61c0>] (tty_write+0x10c/0x26c)
[    5.018951] [<c03b61c0>] (tty_write) from [<c03b63c4>] (redirected_tty_write+0xa4/0xb8)
[    5.027038] [<c03b63c4>] (redirected_tty_write) from [<c0168f38>] (vfs_write+0xb4/0x1bc)
[    5.035217] [<c0168f38>] (vfs_write) from [<c0169380>] (SyS_write+0x4c/0x98)
[    5.042358] [<c0169380>] (SyS_write) from [<c000eee0>] (ret_fast_syscall+0x0/0x48)
[    5.050018] Code: e3a02000 ee072fba e3a01001 f5d3f000 (e1d30f9f) 

