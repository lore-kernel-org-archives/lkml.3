Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaAQJmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:42:25 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:52831 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbaAQJmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:42:21 -0500
Message-ID: <1389951739.16580.4.camel@x220>
Subject: Re: [BUG] Panic when booting
From: Paul Bolle <pebolle@tiscali.nl>
To: Madper Xie <cxie@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Jan 2014 10:42:19 +0100
In-Reply-To: <87r4877y07.fsf@redhat.com>
References: <87r4877y07.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2014 09:42:19.0600 (UTC) FILETIME=[6A2E9D00:01CF1368]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 17:34 +0800, Madper Xie wrote:
> I meet following panic when I booting my HP Compad Elite 8300 Elite SFF
> desktop.
> 
> [call trace here:]
> [    0.569993] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> [    0.578269] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-rc8 #1
> [    0.585496] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
> [    0.594639]  ffffffffffffffff ffff880213125d70 ffffffff815dd70e ffffffff817e8598
> [    0.602100]  ffff880213125de8 ffffffff815d72bb ffffffff00000010 ffff880213125df8
> [    0.609570]  ffff880213125d98 ffff880213125da0 ffff880213125e08 0000000000000012
> [    0.617050] Call Trace:
> [    0.619511]  [<ffffffff815dd70e>] dump_stack+0x45/0x56
> [    0.624664]  [<ffffffff815d72bb>] panic+0xc8/0x1d7
> [    0.629470]  [<ffffffff81a36502>] mount_block_root+0x2a1/0x2b0
> [    0.635309]  [<ffffffff81a36564>] mount_root+0x53/0x56
> [    0.640467]  [<ffffffff81a366a3>] prepare_namespace+0x13c/0x174
> [    0.646392]  [<ffffffff81a36184>] kernel_init_freeable+0x218/0x22b
> [    0.652578]  [<ffffffff81a358d0>] ? do_early_param+0x88/0x88
> [    0.658245]  [<ffffffff815cc450>] ? rest_init+0x80/0x80
> [    0.663493]  [<ffffffff815cc45e>] kernel_init+0xe/0x120
> [    0.668724]  [<ffffffff815ed43c>] ret_from_fork+0x7c/0xb0
> [    0.674125]  [<ffffffff815cc450>] ? rest_init+0x80/0x80
> [    0.792437] Rebooting in 3 seconds..

[...]

> I can reproduce it 100%.
> Will do a bisect next monday if no one has clue.

I'd double check my bootloader configuration and the initramfs (which
you're probably using) if I'd encountered ab backtrace like that before
bisecting. But we seem to be missing quite a bit of dmesg's output, so
that's a bit of a guess...


Paul Bolle

