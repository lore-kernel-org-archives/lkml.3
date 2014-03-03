Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaCCI7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:59:02 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaCCI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:59:00 -0500
Date: Mon, 3 Mar 2014 11:58:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Axel Rasmussen <axel.rasmussen1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] drivers: staging: rtl8187se: wrap excessively long
 lines
Message-ID: <20140303085847.GI26722@mwanda>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
 <1393737773-13937-4-git-send-email-axel.rasmussen1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393737773-13937-4-git-send-email-axel.rasmussen1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch introduces bugs.  Please redo and be more careful next time.

On Sat, Mar 01, 2014 at 10:22:47PM -0700, Axel Rasmussen wrote:
> Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
> @@ -935,7 +946,8 @@ static short alloc_rx_desc_ring(struct net_device *dev, u16 bufsize, int count)
>  		tmp = tmp+rx_desc_size;
>  	}
>  
> -	*(tmp-rx_desc_size) = *(tmp-rx_desc_size) | (1<<30); /* this is the last descriptor */
> +	/* this is the last descriptor */
> +	*(tmp - rx_desc_size) = (*tmp-rx_desc_size) | (1 << 30);

You changed "*(tmp-rx_desc_size)" to "(*tmp-rx_desc_size)".

regards,
dan carpenter

