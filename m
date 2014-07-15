Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbaGOInU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:43:20 -0400
Received: from eu1sys200aog127.obsmtp.com ([207.126.144.176]:55953 "EHLO
	eu1sys200aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757584AbaGOInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:43:13 -0400
Message-ID: <53C4E990.6080402@mellanox.com>
Date: Tue, 15 Jul 2014 11:42:56 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <roland@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <haggaie@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Roland Dreier" <roland@purestorage.com>
Subject: Re: [PATCH for 3.16] IB/mlx5: Enable block multicast loopback for
 kernel consumers too
References: <1403703854-14328-1-git-send-email-ogerlitz@mellanox.com>
In-Reply-To: <1403703854-14328-1-git-send-email-ogerlitz@mellanox.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.223.0.19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/2014 16:44, Or Gerlitz wrote:
> Under commit f360d88 we advertize blocking multicast loopback to both
> kernel and user-space consumers, but disallow the kernel ones (e.g IPoIB)
> to use it with their UD QPs, fix that.
>
> Fixes: f360d88 ('IB/mlx5: Add block multicast loopback support')
> Reported-by: Haggai Eran <haggaie@mellanox.com>
> Signed-off-by: Eli Cohen <eli@mellanox.com>
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---

Roland, this needs to go into 3.16 and 3.15-stable too as the bug was 
introduced in 3.15-rc2, please make sure to add it to your 3.16 rc pull 
request, OK?

Or.

>   drivers/infiniband/hw/mlx5/qp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index d13ddf1..bbbcf38 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -675,7 +675,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
>   	int err;
>
>   	uuari = &dev->mdev.priv.uuari;
> -	if (init_attr->create_flags & ~IB_QP_CREATE_SIGNATURE_EN)
> +	if (init_attr->create_flags & ~(IB_QP_CREATE_SIGNATURE_EN | IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK))
>   		return -EINVAL;
>
>   	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
>

