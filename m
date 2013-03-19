Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3CSCrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:47:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62962 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab3CSCr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:47:29 -0400
Date: Mon, 18 Mar 2013 19:43:37 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] s3c-adc-battery: Fix possible NULL pointer dereference
Message-ID: <20130319024336.GD14118@lizard.gateway.2wire.net>
References: <1361747005-29306-1-git-send-email-s.syam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361747005-29306-1-git-send-email-s.syam@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:33:25AM +0530, Syam Sidhardhan wrote:
> Check for (bat == NULL) has to be done before accessing bat
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> ---

Applied, thanks!

>  drivers/power/s3c_adc_battery.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
> index d2ca989..5948ce0 100644
> --- a/drivers/power/s3c_adc_battery.c
> +++ b/drivers/power/s3c_adc_battery.c
> @@ -145,14 +145,17 @@ static int s3c_adc_bat_get_property(struct power_supply *psy,
>  
>  	int new_level;
>  	int full_volt;
> -	const struct s3c_adc_bat_thresh *lut = bat->pdata->lut_noac;
> -	unsigned int lut_size = bat->pdata->lut_noac_cnt;
> +	const struct s3c_adc_bat_thresh *lut;
> +	unsigned int lut_size;
>  
>  	if (!bat) {
>  		dev_err(psy->dev, "no battery infos ?!\n");
>  		return -EINVAL;
>  	}
>  
> +	lut = bat->pdata->lut_noac;
> +	lut_size = bat->pdata->lut_noac_cnt;
> +
>  	if (bat->volt_value < 0 || bat->cur_value < 0 ||
>  		jiffies_to_msecs(jiffies - bat->timestamp) >
>  			BAT_POLL_INTERVAL) {
> -- 
> 1.7.9.5
