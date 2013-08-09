Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031295Ab3HIVzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:55:32 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62710 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243Ab3HIVza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:55:30 -0400
Date: Fri, 9 Aug 2013 14:50:50 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: power: replace strict_strtol() with kstrtol()
Message-ID: <20130809215050.GF12638@lizard.sbx05730.santaca.wayport.net>
References: <000d01ce844e$767b4a30$6371de90$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000d01ce844e$767b4a30$6371de90$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 04:06:16PM +0900, Jingoo Han wrote:
> The usage of strict_strtol() is not preferred, because
> strict_strtol() is obsolete. Thus, kstrtol() should be
> used.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

Applied, thanks.

>  drivers/power/power_supply_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
> index 29178f7..44420d1 100644
> --- a/drivers/power/power_supply_sysfs.c
> +++ b/drivers/power/power_supply_sysfs.c
> @@ -118,7 +118,7 @@ static ssize_t power_supply_store_property(struct device *dev,
>  	long long_val;
>  
>  	/* TODO: support other types than int */
> -	ret = strict_strtol(buf, 10, &long_val);
> +	ret = kstrtol(buf, 10, &long_val);
>  	if (ret < 0)
>  		return ret;
>  
> -- 
> 1.7.10.4
