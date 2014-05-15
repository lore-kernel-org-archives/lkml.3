Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaEOOOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:14:14 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:47556 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbaEOOON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:14:13 -0400
Message-ID: <5374CAE4.2080305@mellanox.com>
Date: Thu, 15 May 2014 17:10:44 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
CC: Yuval Atias <yuvala@mellanox.com>, Amir Vadai <amirv@mellanox.com>
Subject: Re: randconfig build error with next-20140515, in drivers/net/ethernet/mellanox/mlx4/eq.c
References: <CA+r1Zhg2eT=MxzTmrv=mrhRMRgmFQx3FETLSf42-gGQUxqLOaw@mail.gmail.com>
In-Reply-To: <CA+r1Zhg2eT=MxzTmrv=mrhRMRgmFQx3FETLSf42-gGQUxqLOaw@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/05/2014 16:48, Jim Davis wrote:
> Building with the attached random configuration file,
>
> drivers/net/ethernet/mellanox/mlx4/eq.c:58:29: error: field ‘notify’
> has incomplete type
>    struct irq_affinity_notify notify;
>                               ^
> In file included from include/linux/interrupt.h:5:0,
>                   from drivers/net/ethernet/mellanox/mlx4/eq.c:34:
> drivers/net/ethernet/mellanox/mlx4/eq.c: In function ‘mlx4_irq_notifier_notify’:
> include/linux/kernel.h:834:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/net/ethernet/mellanox/mlx4/eq.c:1094:30: note: in expansion of
> macro ‘container_of’
>    struct mlx4_irq_notify *n = container_of(notify,
>                                ^
> include/linux/kernel.h:834:48: warning: (near initialization for ‘n’)
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/net/ethernet/mellanox/mlx4/eq.c:1094:30: note: in expansion of
> macro ‘container_of’
>    struct mlx4_irq_notify *n = container_of(notify,
>                                ^
> drivers/net/ethernet/mellanox/mlx4/eq.c:1104:24: error: dereferencing
> pointer to incomplete type
>     if (cq->irq == notify->irq)
>                          ^
> In file included from include/linux/interrupt.h:5:0,
>                   from drivers/net/ethernet/mellanox/mlx4/eq.c:34:
> drivers/net/ethernet/mellanox/mlx4/eq.c: In function
> ‘mlx4_release_irq_notifier’:
> include/linux/kernel.h:834:48: warning: initialization from
> incompatible pointer type [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/net/ethernet/mellanox/mlx4/eq.c:1111:30: note: in expansion of
> macro ‘container_of’
>    struct mlx4_irq_notify *n = container_of(ref, struct mlx4_irq_notify,
>                                ^
> include/linux/kernel.h:834:48: warning: (near initialization for ‘n’)
> [enabled by default]
>    const typeof( ((type *)0)->member ) *__mptr = (ptr); \
>                                                  ^
> drivers/net/ethernet/mellanox/mlx4/eq.c:1111:30: note: in expansion of
> macro ‘container_of’
>    struct mlx4_irq_notify *n = container_of(ref, struct mlx4_irq_notify,
>                                ^
> drivers/net/ethernet/mellanox/mlx4/eq.c: In function ‘mlx4_assign_irq_notifier’:
> drivers/net/ethernet/mellanox/mlx4/eq.c:1133:2: error: implicit
> declaration of function ‘irq_set_affinity_notifier’
> [-Werror=implicit-function-declaration]
>    err = irq_set_affinity_notifier(irq, &irq_notifier->notify);
>    ^
> cc1: some warnings being treated as errors

I can see the problem, irq_set_affinity_notifier isn't defined when CONFIG_SMP isn't set, I am copying here the developer and he would work on a fix.

Or.


