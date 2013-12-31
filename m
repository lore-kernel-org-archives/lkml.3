Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3LaHwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 02:52:22 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42207 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3LaHwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 02:52:20 -0500
Date: Tue, 31 Dec 2013 09:52:34 +0200
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Roland Dreier <roland@kernel.org>, kernel-janitors@vger.kernel.org,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH 5/25] IB/mlx4: fix error return code
Message-ID: <20131231095234.28f33123@jpm-OptiPlex-GX620>
In-Reply-To: <1388357260-4843-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	<1388357260-4843-6-git-send-email-Julia.Lawall@lip6.fr>
Organization: Mellanox
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Dec 2013 23:47:20 +0100
Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> diff --git a/drivers/infiniband/hw/mlx4/sysfs.c
> b/drivers/infiniband/hw/mlx4/sysfs.c index 97516eb..db2ea31 100644
> --- a/drivers/infiniband/hw/mlx4/sysfs.c
> +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> @@ -582,8 +582,10 @@ static int add_port(struct mlx4_ib_dev *dev, int
> port_num, int slave) p->pkey_group.attrs =
>  		alloc_group_attrs(show_port_pkey, store_port_pkey,
>  				  dev->dev->caps.pkey_table_len[port_num]);
> -	if (!p->pkey_group.attrs)
> +	if (!p->pkey_group.attrs) {
> +		ret = -ENOMEM;
>  		goto err_alloc;
> +	}
>  
>  	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
>  	if (ret)
> @@ -591,8 +593,10 @@ static int add_port(struct mlx4_ib_dev *dev, int
> port_num, int slave) 
>  	p->gid_group.name  = "gid_idx";
>  	p->gid_group.attrs = alloc_group_attrs(show_port_gid_idx,
> NULL, 1);
> -	if (!p->gid_group.attrs)
> +	if (!p->gid_group.attrs) {
> +		ret = -ENOMEM;
>  		goto err_free_pkey;
> +	}
>  

ACK. Julia's patch is correct -- this is indeed a bug-fix.

-Jack
