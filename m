Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbaLPB5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:57:17 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:39087 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaLPB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:57:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141216124750.153e3fdd@canb.auug.org.au>
References: <20141216124750.153e3fdd@canb.auug.org.au>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 15 Dec 2014 17:56:55 -0800
X-Google-Sender-Auth: _AFpvZ27CyXwH_dOMET6gJFSxEw
Message-ID: <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 5:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the infiniband tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_query_device':
> drivers/infiniband/hw/mlx5/main.c:248:34: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>   if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
>                                   ^
> drivers/net/ethernet/mellanox/mlx5/core/fw.c: In function 'mlx5_query_odp_caps':
> drivers/net/ethernet/mellanox/mlx5/core/fw.c:79:30: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>   if (!(dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
>                               ^
> drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function 'mlx5_start_eqs':
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:459:28: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>   if (dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
>                             ^
>
> Really?  Code added half way though the merge window not even build
> tested?

It's not quite as bad as it seems.  The infiniband tree itself builds,
the problem is the merged tree.

The Mellanox guys merged the "cleanup"

commit 0c7aac854f52
Author: Eli Cohen <eli@dev.mellanox.co.il>
Date:   Tue Dec 2 02:26:14 2014

    net/mlx5_core: Remove unused dev cap enum fields

    These enumerations are not used so remove them.

    Signed-off-by: Eli Cohen <eli@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

through davem's tree, and then went ahead and used at least
MLX5_DEV_CAP_FLAG_ON_DMND_PG (which that patch removes) in patches
they merged through my tree.

I'll add a partial revert of that patch to my tree to get back the
now-used enum values.

 - R.
