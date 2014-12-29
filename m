Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaL2MEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:04:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaL2MEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:04:01 -0500
Date: Mon, 29 Dec 2014 13:03:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.mathur@samsung.com, Jason Gerecke <killertofu@gmail.com>,
        Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH] hid: Initialize battery_no to -1 & correct its format
 string
In-Reply-To: <1419782872-2991-1-git-send-email-aniroop.mathur@gmail.com>
Message-ID: <alpine.LNX.2.00.1412291302470.1680@pobox.suse.cz>
References: <1419782872-2991-1-git-send-email-aniroop.mathur@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2014, Aniroop Mathur wrote:

> From: Aniroop Mathur <a.mathur@samsung.com>
> 
> This patch initializes battery_no to -1 to avoid extra subtraction
> operation performed everytime wacom battery is initialized 

This is so femto-optimization, that I don't really care deeply. Adding 
Jason and Ping to CC. If they want this, I'll apply the patch.

> and correct format string of unsigned long from %ld to %lu.
> 
> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
> ---
>  drivers/hid/wacom_sys.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 129fd33..4b5ff84 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -919,17 +919,17 @@ static int wacom_ac_get_property(struct power_supply *psy,
>  
>  static int wacom_initialize_battery(struct wacom *wacom)
>  {
> -	static atomic_t battery_no = ATOMIC_INIT(0);
> +	static atomic_t battery_no = ATOMIC_INIT(-1);
>  	int error;
>  	unsigned long n;
>  
>  	if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) {
> -		n = atomic_inc_return(&battery_no) - 1;
> +		n = atomic_inc_return(&battery_no);
>  
>  		wacom->battery.properties = wacom_battery_props;
>  		wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
>  		wacom->battery.get_property = wacom_battery_get_property;
> -		sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%ld", n);
> +		sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%lu", n);
>  		wacom->battery.name = wacom->wacom_wac.bat_name;
>  		wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
>  		wacom->battery.use_for_apm = 0;
> @@ -937,7 +937,7 @@ static int wacom_initialize_battery(struct wacom *wacom)
>  		wacom->ac.properties = wacom_ac_props;
>  		wacom->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
>  		wacom->ac.get_property = wacom_ac_get_property;
> -		sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%ld", n);
> +		sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%lu", n);
>  		wacom->ac.name = wacom->wacom_wac.ac_name;
>  		wacom->ac.type = POWER_SUPPLY_TYPE_MAINS;
>  		wacom->ac.use_for_apm = 0;
> -- 
> 1.9.1
> 

-- 
Jiri Kosina
SUSE Labs
