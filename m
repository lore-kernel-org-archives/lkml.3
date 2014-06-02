Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaFBE4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 00:56:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56218 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaFBE4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 00:56:51 -0400
Date: Sun, 01 Jun 2014 21:56:50 -0700 (PDT)
Message-Id: <20140601.215650.2131746246978305213.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: amirv@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org,
        yevgenyp@mellanox.com, yuvala@mellanox.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V6 2/2] net/mlx4_en: Use affinity hint
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401683831.3645.169.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1401029247-15196-3-git-send-email-amirv@mellanox.com>
	<1401682610.3645.166.camel@edumazet-glaptop2.roam.corp.google.com>
	<1401683831.3645.169.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Jun 2014 21:56:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s524v4UW027055

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 01 Jun 2014 21:37:11 -0700

> On Sun, 2014-06-01 at 21:16 -0700, Eric Dumazet wrote:
>>   CC [M]  drivers/net/ethernet/mellanox/mlx4/en_netdev.o
>> drivers/net/ethernet/mellanox/mlx4/en_netdev.c: In function ¡mlx4_en_init_affinity_hint¢:
>> drivers/net/ethernet/mellanox/mlx4/en_netdev.c:1546:23: error: incompatible types when assigning to type ¡cpumask_var_t¢ from type ¡void *¢
>> drivers/net/ethernet/mellanox/mlx4/en_netdev.c: In function ¡mlx4_en_free_affinity_hint¢:
>> drivers/net/ethernet/mellanox/mlx4/en_netdev.c:1553:41: error: incompatible types when assigning to type ¡cpumask_var_t¢ from type ¡void *¢
> 
> 
> And :
> 
> ERROR: "cpumask_set_cpu_local_first" [drivers/net/ethernet/mellanox/mlx4/mlx4_en.ko] undefined!
> 
> 
> $ git grep -n cpumask_set_cpu_local_first
> drivers/net/ethernet/mellanox/mlx4/en_netdev.c:1542:    if (cpumask_set_cpu_local_first(ring_idx, numa_node,
> include/linux/cpumask.h:260:int cpumask_set_cpu_local_first(int i, int numa_node, cpumask_t *dstp);
> lib/cpumask.c:168: * cpumask_set_cpu_local_first - set i'th cpu with local numa cpu's first
> lib/cpumask.c:182:int cpumask_set_cpu_local_first(int i, int numa_node, cpumask_t *dstp)
> lib/cpumask.c:228:EXPORT_SYMBOL(cpumask_set_cpu_local_first);
> 
> Fixes are needed if CONFIG_CPUMASK_OFFSTACK is not used.
> 	
> $ grep CONFIG_CPUMASK_OFFSTACK .config
> $ echo $?
> 1
> 

Indeed you have to provide a dummy version for a non-SMP build etc.

I'm reverting.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
