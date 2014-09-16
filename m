Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaIPLtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:49:45 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:39584 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaIPLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:49:44 -0400
MIME-Version: 1.0
Date: Tue, 16 Sep 2014 17:19:43 +0530
Message-ID: <CAP6rfc-36nGq0nZU1pQjUJLMknC26zibeD9hAS6JmmiL+OVSVA@mail.gmail.com>
Subject: =?UTF-8?Q?BUG=3A_scheduling_while_atomic=3A_dslmgmt=2F53=E2=80=8B8=2F0x00000?=
	=?UTF-8?Q?2=E2=80=8B01?=
From: Mushtaq Khan <mushtaqk921@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 I see the error message "BUG: scheduling while atomic: dslmgmt"
intermittently. As per other post on similar issue, this happens when
schedule() is called from either interrupt context or some other
atomic operation (Might be after acquiring spinlock).
 But from the call trace am not getting any clue, please help me guide
on this issue.

 BUG: scheduling while atomic: dslmgmt/538/0x00000201
 Modules linked in: iptable_mangle init_addr(  (null) -   (null)),
core_addr(c036
 9000 - c0369210)
  iptable_filter init_addr(  (null) -   (null)), core_addr(c0362000 - c03620b0)
  ip_tables init_addr(  (null) -   (null)), core_addr(c0359000 - c035b618)
  xt_multiport init_addr(  (null) -   (null)), core_addr(c034f000 - c034f2d8)
  pktflow(P) init_addr(  (null) -   (null)), core_addr(c0067000 - c0074800)
  bcm_bpm(P) init_addr(  (null) -   (null)), core_addr(c0045000 - c0046470)
  bcm_ingqos(P) init_addr(  (null) -   (null)), core_addr(c003a000 - c003b070)
  chipinfo(P) init_addr(  (null) -   (null)), core_addr(c0031000 - c0031198)

 Call Trace:
 [<802a0d6c>] printk+0x24/0x30
 [<80074714>] print_modules+0x88/0x144
 [<802a43c8>] __schedule+0x54c/0x58c
 [<802a12d0>] __schedule_bug+0x38/0x54
 [<802a0b30>] dump_stack+0x8/0x34
 [<802a43c8>] __schedule+0x54c/0x58c
 [<8017d0f0>] do_output_char+0x1b4/0x220
 [<801876ec>] uart_write+0xd8/0x15c
 [<8017d19c>] process_output+0x40/0x6c
 [<802a4580>] schedule+0x58/0xb4
 [<800f1dc0>] fsnotify+0x1b0/0x2dc
 [<802a3514>] do_nanosleep+0xf8/0x13c
 [<80055c98>] hrtimer_nanosleep+0xb4/0x158
 [<80054dd8>] hrtimer_wakeup+0x0/0x2c
 [<80044f00>] sys_rt_sigaction+0x78/0xd4
 [<80055da8>] sys_nanosleep+0x6c/0x94
 [<8001b95c>] stack_done+0x20/0x40
 Call Trace:
 [<802a0b30>] dump_stack+0x8/0x34
 [<802a43c8>] __schedule+0x54c/0x58c
 [<802a4580>] schedule+0x58/0xb4
 [<802a3514>] do_nanosleep+0xf8/0x13c
 [<80055c98>] hrtimer_nanosleep+0xb4/0x158
 [<80055da8>] sys_nanosleep+0x6c/0x94
 [<8001b95c>] stack_done+0x20/0x40

 Regards,
 Mushtaq Khan
