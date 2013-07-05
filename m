Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3GEX0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 19:26:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48441 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3GEX0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 19:26:44 -0400
Message-ID: <51D75623.2010507@gmail.com>
Date: Sat, 06 Jul 2013 09:26:27 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] rapidio: use after free in unregister function
References: <20130705203908.GA7594@elgon.mountain>
In-Reply-To: <20130705203908.GA7594@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/13 06:39, Dan Carpenter wrote:

> We're freeing the list iterator so we can't move to the next entry.
> Since there is only one matching mport_id, we can just break after
> finding it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: cleaner fix than v1
> 
> diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
> index f4f30af..2e8a20c 100644
> --- a/drivers/rapidio/rio.c
> +++ b/drivers/rapidio/rio.c
> @@ -1715,11 +1715,13 @@ int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
>  		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
>  			port->nscan = NULL;
>  
> -	list_for_each_entry(scan, &rio_scans, node)
> +	list_for_each_entry(scan, &rio_scans, node) {
>  		if (scan->mport_id == mport_id) {
>  			list_del(&scan->node);
>  			kfree(scan);
> +			break;
>  		}
> +	}
>  
>  	mutex_unlock(&rio_mport_list_lock);
>  


Reviewed-by: Ryan Mallon <rmallon@gmail.com>

