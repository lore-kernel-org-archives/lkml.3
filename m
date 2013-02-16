Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3BPVgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:36:33 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:65015 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3BPVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:36:32 -0500
Date: Sat, 16 Feb 2013 13:32:48 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Message-ID: <20130216213248.GC1741@lizard.sbx05280.losalca.wayport.net>
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com>
 <201302061856.35366@pali>
 <20130209015718.GA13561@lizard.sbx05663.mountca.wayport.net>
 <201302091202.16019@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302091202.16019@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2013 at 12:02:15PM +0100, Pali Rohár wrote:
> On Saturday 09 February 2013 02:57:18 Anton Vorontsov wrote:
> > 
> > Hm. The documentation says tenth (1/10) degrees, and you even
> > restate it in the commit message. But the subject, and your
> > example seem to prove that you still report it in 1/100 of
> > Celsius.
> > 
> > Unless your phone was on fire during the time you took the
> > values, I tend to think the patch needs to be fixed. :-)
> > 
> > Thanks,
> > Anton
> > 
> 
> Ah, my mistake. I very quicky looked that bq and rx driver
> reporting different values... But bad conversation is in
> rx51_battery driver, not in bq. So drop previous bq patch...
> 
> Here is patch for rx51_battery. I think now it should report
> correct temperature. On Nokia N900 it reporting: POWER_SUPPLY_TEMP=350
> 
> From 92efbf24ac2fdc7af41abb12afd5e8c319479f6b Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
> Date: Sat, 9 Feb 2013 11:06:48 +0100
> Subject: [PATCH] =?UTF-8?q?rx51=5Fbattery:=20Fix=20reporting=20temperature=20?=
>  =?UTF-8?q?(in=201/10=20=C2=B0C)?=
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit

The patch is missing signed-off-by tag and commit message. :-/

Thanks,

> ---
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
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com
