Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbaLJXvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:51:35 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37695 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbaLJXve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141210232911.GE24163@wfg-t540p.sh.intel.com>
References: <20141210232911.GE24163@wfg-t540p.sh.intel.com>
Date: Wed, 10 Dec 2014 15:51:33 -0800
Message-ID: <CAMEtUuxexMXtvK_R7YZEvx_iyK9mAx_zrqr1bkj3PsUwoq0p5A@mail.gmail.com>
Subject: Re: [net: sock] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000007
From: Alexei Starovoitov <ast@plumgrid.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 3:29 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
>     net: sock: allow eBPF programs to be attached to sockets

> [init] Kernel was tainted on startup. Will ignore flags that are already set.
> [init] Started watchdog process, PID is 9354
> [main] Main thread is alive.
> [   21.233581] BUG: unable to handle kernel NULL pointer dereference at 0000000000000007
> [   21.234709] IP: [<ffffffff8156ebda>] sk_attach_bpf+0x39/0xc2

thanks for the report! syscall fuzzer is great.
I missed an extra check. Working on a fix.
