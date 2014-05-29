Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaE2M3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:29:42 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:64602 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbaE2M3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E9012BF05ED1@SHAASIEXM01.ASIA.ROOT.PRI>
References: <20140529172858.43a0063a@canb.auug.org.au> <5EB3BFCD089AD643B9BB63439F5FD5E9012BF05ED1@SHAASIEXM01.ASIA.ROOT.PRI>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 29 May 2014 20:29:20 +0800
Message-ID: <CAGsJ_4xjYxXgQLDka0J3M3+FSHVQ2LmvgcWKUiqdhQ20gxCFsw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tty tree
To: sfr@canb.auug.org.au, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qipan Li <Qipan.Li@csr.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-29 20:18 GMT+08:00 Barry Song <Barry.Song@csr.com>:
> From: Stephen Rothwell [sfr@canb.auug.org.au]
> Sent: Thursday, May 29, 2014 15:28
> To: Greg KH
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Qipan Li; Barry Song
> Subject: linux-next: build failure after merge of the tty tree
>
> Hi Greg,
>
> After merging the tty tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>
> drivers/tty/serial/sirfsoc_uart.c: In function 'sirfsoc_uart_rx_dma_complete_tl':
> drivers/tty/serial/sirfsoc_uart.c:707:2: error: 'struct uart_port' has no member named 'rx_lock'
>
> Caused by commit 07d410e06463 ("serial: sirf: fix spinlock deadlock
> issue").  Did anyone even build test this? Much less test that it fixed
> the deadlock ... :-(
>

Stephen, it is my fault. qipan did a strange mis-operation when he
prepared this patch and i didn't double-confirm it.
but the patch did have been tested on real hardware to fix the
deadlock issue. it is not a patch without test.

the build issue has been fixed in another thread: [PATCH tty-next]
serial: sirf: Fix compilation failure
https://lkml.org/lkml/2014/5/29/476

i am very sorry for this as the related platform maintainer. i didn't
control this well and missed to do a double build for this. again, i
am very sorry!

> I have used the tty tree from next-20140528 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>

-barry
