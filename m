Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaEEHf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:35:26 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:47768 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbaEEHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:35:25 -0400
Message-ID: <53673E13.6070708@mellanox.com>
Date: Mon, 5 May 2014 10:30:27 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, <netdev@vger.kernel.org>
CC: Eli Cohen <eli@mellanox.com>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] mellanox: Logging message cleanups
References: <e029b6ed75d46cfbada06622df91d4d331eeabde.1399259459.git.joe@perches.com>
In-Reply-To: <e029b6ed75d46cfbada06622df91d4d331eeabde.1399259459.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2014 6:35 AM, Joe Perches wrote:
> Use a more current logging style.
>
> o Coalesce formats
> o Add missing spaces for coalesced formats
> o Align arguments for modified formats
> o Add missing newlines for some logging messages
> o Use DRV_NAME as part of format instead of %s, DRV_NAME to
>    reduce overall text.
> o Use ..., ##__VA_ARGS__ instead of args... in macros
> o Correct a few format typos
> o Use a single line message where appropriate
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cmd.c           |  85 ++++---
>   drivers/net/ethernet/mellanox/mlx4/en_cq.c         |   3 +-
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   6 +-
>   drivers/net/ethernet/mellanox/mlx4/en_main.c       |   7 +-
>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   8 +-
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c         |  17 +-
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   8 +-
>   drivers/net/ethernet/mellanox/mlx4/eq.c            |  85 +++----
>   drivers/net/ethernet/mellanox/mlx4/fw.c            |  25 +--
>   drivers/net/ethernet/mellanox/mlx4/main.c          | 246 +++++++++------------
>   drivers/net/ethernet/mellanox/mlx4/mcg.c           |  16 +-
>   drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  17 +-
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |  40 ++--
>   drivers/net/ethernet/mellanox/mlx4/mr.c            |  14 +-
>   drivers/net/ethernet/mellanox/mlx4/port.c          |  12 +-
>   drivers/net/ethernet/mellanox/mlx4/profile.c       |  13 +-
>   drivers/net/ethernet/mellanox/mlx4/qp.c            |   7 +-
>   drivers/net/ethernet/mellanox/mlx4/reset.c         |  24 +-
>   .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  73 +++---
>   drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   4 +-
>   drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   9 +-
>   drivers/net/ethernet/mellanox/mlx5/core/main.c     |  14 +-
>   .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  30 +--
>   drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   8 +-
>   .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  15 +-
>   drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   4 +-
>   26 files changed, 353 insertions(+), 437 deletions(-)
>

[...]

>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
> index d16a4d1..0a87169 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/fw.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
> @@ -1,3 +1,4 @@
> +
new line

>   /*
>    * Copyright (c) 2004, 2005 Topspin Communications.  All rights reserved.
>    * Copyright (c) 2005, 2006, 2007, 2008 Mellanox Technologies. All rights reserved.
> @@ -428,8 +429,7 @@ int mlx4_QUERY_FUNC_CAP(struct mlx4_dev *dev, u32 gen_or_port,
>   	} else if (dev->caps.port_type[gen_or_port] == MLX4_PORT_TYPE_IB) {
>   		MLX4_GET(field, outbox, QUERY_FUNC_CAP_FLAGS0_OFFSET);
>   		if (field & QUERY_FUNC_CAP_FLAGS0_FORCE_PHY_WQE_GID) {
> -			mlx4_err(dev, "phy_wqe_gid is "
> -				 "enforced on this ib port\n");
> +			mlx4_err(dev, "phy_wqe_gid is enforced on this ib port\n");
>   			err = -EPROTONOSUPPORT;
>   			goto out;
>   		}

[...]

Acked-By: Amir Vadai <amirv@mellanox.com>

Thanks,
Amir
