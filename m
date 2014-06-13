Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaFMRAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:00:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFMRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:00:43 -0400
Date: Fri, 13 Jun 2014 10:04:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Cc: linux-kernel@vger.kernel.org, matlackdavid@gmail.com, liodot@gmail.com,
        charrer@alacritech.com, peter.p.waskiewicz.jr@intel.com,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: slicoss: Fix coding style issue
Message-ID: <20140613170435.GA18608@kroah.com>
References: <1402674753-3466-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402674753-3466-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 05:52:33PM +0200, Benedict Boerger wrote:
> Fix a coding style issue found by checkpatch.pl.
> Use ether_addr_copy instead of memcpy.
> 
> Done to complete a eudyptula task.
> 
> Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
> 
> ---
>  drivers/staging/slicoss/slicoss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index 48841e7..02807a3 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -1790,7 +1790,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
>  	if (mcaddr == NULL)
>  		return 1;
>  
> -	memcpy(mcaddr->address, address, ETH_ALEN);
> +	ether_addr_copy(mcaddr->address, address);
>  
>  	mcaddr->next = adapter->mcastaddrs;
>  	adapter->mcastaddrs = mcaddr;

Are you sure this is correct?  It's not always a one-to-one replacement
from what I have been told.

thanks,

greg k-h
