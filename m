Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbaHELSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:18:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29947 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaHELSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:18:48 -0400
Date: Tue, 5 Aug 2014 14:18:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christoph Jaeger <email@christophjaeger.info>
Cc: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] staging: ozwpan: Use slab cache for oz_urb_link
 allocation
Message-ID: <20140805111829.GU4856@mwanda>
References: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
 <1407156896-3246-8-git-send-email-email@christophjaeger.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407156896-3246-8-git-send-email-email@christophjaeger.info>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 02:54:53PM +0200, Christoph Jaeger wrote:
> @@ -2341,6 +2289,11 @@ int oz_hcd_init(void)
>  
>  	if (usb_disabled())
>  		return -ENODEV;
> +
> +	oz_urb_link_cache = KMEM_CACHE(oz_urb_link, 0);
> +	if (unlikely(!oz_urb_link_cache))
> +		return -ENOMEM;

Don't put unlikely() calls in driver code.  It just makes it messy for
no reason.  "Oooo!  I can modprobe/rmmod this driver 1000000 times in a
row and it speeds it up .0003 seconds because I added an unlikely tag!"

regards,
dan carpenter

