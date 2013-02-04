Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3BDXCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:02:13 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48470 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3BDXCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <l2c0h896p2of3i8l6ivc6di7n7s72sbve3@4ax.com>
References: <l2c0h896p2of3i8l6ivc6di7n7s72sbve3@4ax.com>
Date: Mon, 4 Feb 2013 16:02:07 -0700
Message-ID: <CAKocOOPa8DDmy41L188K-yZ5FSnvWaF7kMu=A9xWg851FOLxmA@mail.gmail.com>
Subject: Re: 3.7.5: Kernel panic on halt
From: Shuah Khan <shuahkhan@gmail.com>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 3:18 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
> Hi there,
>
> I was running machine overnight on 12V battery test, with this simple
> kernel compile loop:
>
>   grant@itxmini:~/linux/linux-3.7.5a$ while :; do make clean; make -j5; done
>
> Today it was time to shutdown the box ('halt' command) and recharge the battery.
>
> Snapshot of screen:
>
>   http://bugsplatter.id.au/misc/image/IMG_5627-kernel-panic-itxmini-2013-01-05.jpg
>
> Kernel .config and dmesg:
>
>   http://bugsplatter.id.au/kernel/boxen/itxmini/config-3.7.5a.gz
>   http://bugsplatter.id.au/kernel/boxen/itxmini/dmesg-3.7.5a.gz
>
> Box is Intel D510MO mobo with dual core HT Atom CPU with 2GB memory, 2GB
> swap (unused), Intel pro/100 NIC (disconnected), onboard PS/2 keyboard,
> ps/2 mouse, 1Gbps NIC, VGA monitor connected.
>
> What next?  Box rebooted normally.  Ha
>
> Thanks,
> Grant.

Will you be able to run gdb on your kernel to see where exactly it is
failing: If read the faulting address from the attached jpg correctly,
the following sequence should get us the failing source code line:

gdb vmlinux
x/10i run_timer_softirq+0xac
info line *disassaddr for run_timer_softirq+0xac

-- Shuah
