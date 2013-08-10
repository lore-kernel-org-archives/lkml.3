Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab3HJHPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 03:15:48 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56586 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab3HJHPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 03:15:46 -0400
Date: Sat, 10 Aug 2013 00:15:39 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mtd: add a new sys node to show the ecc step size
Message-ID: <20130810071536.GA3467@norris.computersforpeace.net>
References: <1368607606-4344-1-git-send-email-b32955@freescale.com>
 <1368607606-4344-3-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368607606-4344-3-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 04:46:44PM +0800, Huang Shijie wrote:
> Add a new sys node to show the ecc step size.
> The application then can uses this node to get the ecc step
> size.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/mtdcore.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index c400c57..63903b9 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -285,6 +285,16 @@ static DEVICE_ATTR(bitflip_threshold, S_IRUGO | S_IWUSR,
>  		   mtd_bitflip_threshold_show,
>  		   mtd_bitflip_threshold_store);
>  
> +static ssize_t mtd_ecc_step_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct mtd_info *mtd = dev_get_drvdata(dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->ecc_step);

ecc_step is an unsigned int, so why cast to unsigned long? Just use:

	return snprintf(buf, PAGE_SIZE, "%u\n", mtd->ecc_step);

> +
> +}
> +static DEVICE_ATTR(ecc_step, S_IRUGO, mtd_ecc_step_show, NULL);
> +
>  static struct attribute *mtd_attrs[] = {
>  	&dev_attr_type.attr,
>  	&dev_attr_flags.attr,

...

Brian
