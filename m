Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab3GOPxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:53:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43358 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3GOPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:53:03 -0400
Message-ID: <51E41AB2.3020905@infradead.org>
Date: Mon, 15 Jul 2013 08:52:18 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eli Cohen <eli@mellanox.com>
Subject: Re: [PATCH 3.11-rc1] mlx5 core: Fix __udivdi3 when compiling for
 32 bit arches
References: <1373900205-69711-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1373900205-69711-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/13 07:56, Tim Gardner wrote:
> Cc: Eli Cohen <eli@mellanox.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

I reported this last week and Eli wrote:

"I have this fixed in my tree and we run the driver on i386. I will check on Sunday why it is not in the patches submitted."

Anyway, the patch works for me.

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/debugfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
> index 4273c06..9c7194b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
> @@ -156,7 +156,7 @@ static ssize_t average_read(struct file *filp, char __user *buf, size_t count,
>  	stats = filp->private_data;
>  	spin_lock(&stats->lock);
>  	if (stats->n)
> -		field = stats->sum / stats->n;
> +		field = div64_u64(stats->sum, stats->n);
>  	spin_unlock(&stats->lock);
>  	ret = snprintf(tbuf, sizeof(tbuf), "%llu\n", field);
>  	if (ret > 0) {
> 


-- 
~Randy
