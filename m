Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3KGR4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:56:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53107 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230Ab3KGR41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:56:27 -0500
Message-ID: <527BD449.4070809@free-electrons.com>
Date: Thu, 07 Nov 2013 18:56:25 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, rob.herring@calxeda.com,
        linux@arm.linux.org.uk, kernel@pengutronix.de, baohua@kernel.org,
        dinguyen@altera.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/3] bus: mvebu: add missing of_node_put() to fix reference
 leak
References: <1383793720-4643-1-git-send-email-jszhang@marvell.com> <1383793720-4643-5-git-send-email-jszhang@marvell.com>
In-Reply-To: <1383793720-4643-5-git-send-email-jszhang@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:08, Jisheng Zhang wrote:
> Add of_node_put to properly decrement the refcount when we are
> done using a given node.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>


Thanks,

Gregory

> ---
>  drivers/bus/mvebu-mbus.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
> index 33c6947..20da90f 100644
> --- a/drivers/bus/mvebu-mbus.c
> +++ b/drivers/bus/mvebu-mbus.c
> @@ -837,6 +837,7 @@ int __init mvebu_mbus_init(const char *soc, phys_addr_t mbuswins_phys_base,
>  {
>  	struct mvebu_mbus_state *mbus = &mbus_state;
>  	const struct of_device_id *of_id;
> +	struct device_node *np;
>  	int win;
>  
>  	for (of_id = of_mvebu_mbus_ids; of_id->compatible; of_id++)
> @@ -860,8 +861,11 @@ int __init mvebu_mbus_init(const char *soc, phys_addr_t mbuswins_phys_base,
>  		return -ENOMEM;
>  	}
>  
> -	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric"))
> +	np = of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric");
> +	if (np) {
>  		mbus->hw_io_coherency = 1;
> +		of_node_put(np);
> +	}
>  
>  	for (win = 0; win < mbus->soc->num_wins; win++)
>  		mvebu_mbus_disable_window(mbus, win);
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
