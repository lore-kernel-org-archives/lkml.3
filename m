Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936177Ab3DQBh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:37:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62653 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab3DQBh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:37:56 -0400
Date: Tue, 16 Apr 2013 18:33:53 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: rx51_battery: Fix reporting temperature
Message-ID: <20130417013352.GB18418@lizard.mcd26095.sjc.wayport.net>
References: <20130216213248.GC1741@lizard.sbx05280.losalca.wayport.net>
 <1364488943-6481-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364488943-6481-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 05:42:23PM +0100, Pali Rohár wrote:
> This patch fixing units (1/10 °C) in which is temperature reported.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---

Applied, thanks!

>  drivers/power/rx51_battery.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
> index 8208888..527d256 100644
> --- a/drivers/power/rx51_battery.c
> +++ b/drivers/power/rx51_battery.c
> @@ -119,7 +119,7 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
>  
>  	/* First check for temperature in first direct table */
>  	if (raw < ARRAY_SIZE(rx51_temp_table1))
> -		return rx51_temp_table1[raw] * 100;
> +		return rx51_temp_table1[raw] * 10;
>  
>  	/* Binary search RAW value in second inverse table */
>  	while (max - min > 1) {
> @@ -132,7 +132,7 @@ static int rx51_battery_read_temperature(struct rx51_device_info *di)
>  			break;
>  	}
>  
> -	return (rx51_temp_table2_first - min) * 100;
> +	return (rx51_temp_table2_first - min) * 10;
>  }
>  
>  /*
> -- 
> 1.7.10.4
