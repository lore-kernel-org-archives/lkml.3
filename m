Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3GYAm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:42:58 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56096 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3GYAm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:42:57 -0400
Message-ID: <51F07489.7010404@gmail.com>
Date: Thu, 25 Jul 2013 10:42:49 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prashant Shah <pshah.mumbai@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mwhitehe@redhat.com,
        kernel-mentors@selenic.com
Subject: Re: [PATCH] Change request_irq() to use struct net_device *dev->name
References: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com>
In-Reply-To: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/13 16:09, Prashant Shah wrote:
> Signed-off-by: Prashant Shah <pshah.mumbai@gmail.com>
> ---
>  drivers/net/ethernet/8390/wd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
> index 03eb3ee..b43a63f 100644
> --- a/drivers/net/ethernet/8390/wd.c
> +++ b/drivers/net/ethernet/8390/wd.c
> @@ -308,7 +308,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
>  
>  	/* Snarf the interrupt now.  There's no point in waiting since we cannot
>  	   share and the board will usually be enabled. */
> -	i = request_irq(dev->irq, ei_interrupt, 0, DRV_NAME, dev);
> +	i = request_irq(dev->irq, ei_interrupt, 0, dev->name, dev);

You should also remove the definition of DRV_NAME, since it is no longer
used. The changelog should probably mention that this will change the
interrupt name (which appears in /proc/interrupts for example) from "wd"
to "eth%d".

~Ryan

