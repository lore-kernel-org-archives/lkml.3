Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaFBEQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 00:16:54 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53603 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaFBEQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 00:16:53 -0400
Message-ID: <1401682610.3645.166.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next V6 2/2] net/mlx4_en: Use affinity hint
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Amir Vadai <amirv@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org,
        Yevgeny Petrilin <yevgenyp@mellanox.com>,
        Yuval Atias <yuvala@mellanox.com>, linux-kernel@vger.kernel.org
Date: Sun, 01 Jun 2014 21:16:50 -0700
In-Reply-To: <1401029247-15196-3-git-send-email-amirv@mellanox.com>
References: <1401029247-15196-1-git-send-email-amirv@mellanox.com>
	 <1401029247-15196-3-git-send-email-amirv@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-25 at 17:47 +0300, Amir Vadai wrote:
> From: Yuval Atias <yuvala@mellanox.com>
> 
> The “affinity hint” mechanism is used by the user space
> daemon, irqbalancer, to indicate a preferred CPU mask for irqs.
> Irqbalancer can use this hint to balance the irqs between the
> cpus indicated by the mask.
> 
> We wish the HCA to preferentially map the IRQs it uses to numa cores
> close to it.  To accomplish this, we use cpumask_set_cpu_local_first(), that
> sets the affinity hint according the following policy:
> First it maps IRQs to “close” numa cores.  If these are exhausted, the
> remaining IRQs are mapped to “far” numa cores.
> 
> Signed-off-by: Yuval Atias <yuvala@mellanox.com>
> Signed-off-by: Amir Vadai <amirv@mellanox.com>
> ---

  CC [M]  drivers/net/ethernet/mellanox/mlx4/en_netdev.o
drivers/net/ethernet/mellanox/mlx4/en_netdev.c: In function ‘mlx4_en_init_affinity_hint’:
drivers/net/ethernet/mellanox/mlx4/en_netdev.c:1546:23: error: incompatible types when assigning to type ‘cpumask_var_t’ from type ‘void *’
drivers/net/ethernet/mellanox/mlx4/en_netdev.c: In function ‘mlx4_en_free_affinity_hint’:
drivers/net/ethernet/mellanox/mlx4/en_netdev.c:1553:41: error: incompatible types when assigning to type ‘cpumask_var_t’ from type ‘void *’


