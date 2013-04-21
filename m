Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3DUMGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 08:06:06 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:17775 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3DUMGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 08:06:04 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Apr 2013 08:06:04 EDT
Message-ID: <5173D409.8010405@bfs.de>
Date: Sun, 21 Apr 2013 13:56:57 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] gru: info leak in gru_get_config_info()
References: <20130421111031.GE6171@elgon.mountain>
In-Reply-To: <20130421111031.GE6171@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 21.04.2013 13:10, schrieb Dan Carpenter:
> The "info.fill" array isn't initialized so it can leak uninitialized
> stack information to user space.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
> index 44d273c..ed5fc43 100644
> --- a/drivers/misc/sgi-gru/grufile.c
> +++ b/drivers/misc/sgi-gru/grufile.c
> @@ -176,6 +176,7 @@ static long gru_get_config_info(unsigned long arg)
>  	info.nodes = num_online_nodes();
>  	info.blades = info.nodes / nodesperblade;
>  	info.chiplets = GRU_CHIPLETS_PER_BLADE * info.blades;
> +	memset(&info.fill, 0, sizeof(info.fill));
>  

the other way around (clear first all bytes) looks more easy
in case someone will add more elements to the struct.

memset(&info, 0, sizeof(info));
info.nodes = num_online_nodes();
info.blades = info.nodes / nodesperblade;
....

re,
 wh


>  	if (copy_to_user((void __user *)arg, &info, sizeof(info)))
>  		return -EFAULT;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
