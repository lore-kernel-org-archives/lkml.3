Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaCRUEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:04:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaCRUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:04:42 -0400
Date: Tue, 18 Mar 2014 13:06:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Joe Perches <joe@perches.com>, Rashika Kheria <rashika.kheria@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        devel@driverdev.osuosl.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: slicoss: Fix prefer ether_addr_copy over memcpy
Message-ID: <20140318200644.GA3422@kroah.com>
References: <5327BACF.5020102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5327BACF.5020102@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 09:17:35PM -0600, Joel Pelaez Jorge wrote:
> This patch fixes the following checkpatch.pl issues caused by the new
> function: ether_addr_copy
> 
> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> ---
> diff --git a/drivers/staging/slicoss/slicoss.c
> b/drivers/staging/slicoss/slicoss.c
> index 12aafe3..4ff39aa 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -2313,7 +2313,7 @@ static int slic_mcast_add_list(struct adapter
> *adapter, char *address)
>      if (mcaddr == NULL)
>          return 1;
> 
> -    memcpy(mcaddr->address, address, ETH_ALEN);
> +    ether_addr_copy(mcaddr->address, address);
> 
>      mcaddr->next = adapter->mcastaddrs;
>      adapter->mcastaddrs = mcaddr;

The patch is line-wrapped, and tabs converted to spaces, making it
impossible to apply the patch.

Please fix your email client and try again.

greg k-h
