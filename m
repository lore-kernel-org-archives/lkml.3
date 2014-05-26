Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaEZTcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:32:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaEZTcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:32:03 -0400
Date: Mon, 26 May 2014 22:30:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core/platform: don't leak memory allocated
 for dma_mask
Message-ID: <20140526193046.GJ15585@mwanda>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 06:41:21PM +0200, Emil Goode wrote:
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9e9227e..dd1fa07 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -166,6 +166,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
>  struct platform_object {
>  	struct platform_device pdev;
>  	char name[1];
> +	u64 dma_mask;
>  };

Heh.  No this doesn't work as patch #1.  You have to have name at the
end of the struct.

regards,
dan carpenter

