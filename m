Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3KVQdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:33:03 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39590 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3KVQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:32:59 -0500
Message-ID: <1385137972.10637.86.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [Doubt on Implict BUGs caused LRO] doubt about lro status in
 v3.12 of torvalds/linux.git
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yanfei Wang <backyes@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
        China Kernel <kernel@vger.linux-kernel.cn>,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Nov 2013 08:32:52 -0800
In-Reply-To: <CAJULonje7V_sMt6joBBsM3uuQkYFhfNK70BXzN0EyS3sQNb0uQ@mail.gmail.com>
References: <CAJULonje7V_sMt6joBBsM3uuQkYFhfNK70BXzN0EyS3sQNb0uQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 23:00 +0800, Yanfei Wang wrote:
> Hi,
> 
> Compared to the earlier kernel version, I found that Large receive
> offload(LRO) is obsolete in latest kernel, and that is verified from
> other materials about Generic receive offload(GRO).
> 
> However,  I also found some LRO header files and  lro-related
> functions referred by some drivers, and the lro-related function
> definition is already removed at the same time!
> 
> TEST steps:
> 1. my git local db config as follow, url =
> http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 2. git checkout v3.12 -b 3.12
> 3. cd net/ipv4,
>  [backyes@f14 ipv4]$ cat Makefile | grep lro
> obj-$(CONFIG_INET_LRO) += inet_lro.o
> [backyes@f14 ipv4]$ ls inet_*
> inet_connection_sock.c  inet_diag.c  inet_fragment.c
> inet_hashtables.c  inet_timewait_sock.c
> [backyes@f14 ipv4]$
> Here, Makefile has inet_lro.o config, while the inet_lro.c is removed.
> 4. lro functions referred by some drivers, as follow,
> [backyes@f14 linux]$ grep "inet_lro" * -r
> drivers/net/ethernet/pasemi/pasemi_mac.c:#include <linux/inet_lro.h>
> drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c:#include <linux/inet_lro.h>
> drivers/infiniband/hw/nes/nes_hw.c:#include <linux/inet_lro.h>
> drivers/infiniband/hw/nes/nes_hw.h:#include <linux/inet_lro.h>
> include/linux/inet_lro.h: *  linux/include/linux/inet_lro.h
> net/ipv4/Makefile:obj-$(CONFIG_INET_LRO) += inet_lro.o
> 
> so, I understand that the removal of LRO is not clean, which will
> cause compiler error for some kernel config.
> 

I think you are slightly confused.

LRO is not yet removed.

Feel free to contribute ;)

As long as at least one driver still uses LRO, we can not remove LRO.

Converting a driver means testing the new driver, and owning the
hardware.



