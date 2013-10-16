Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868Ab3JPOJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:09:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44957 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760584Ab3JPOJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:09:42 -0400
Message-ID: <525E9E24.3090401@free-electrons.com>
Date: Wed, 16 Oct 2013 16:09:40 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Anton Vorontsov <anton@enomsg.org>
CC: linux-kernel@vger.kernel.org,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] bq2415x_charger: fix max battery regulation voltage
References: <1381932511-31719-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1381932511-31719-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I forgot to add this is a v2 and I just added a comment.

On 16/10/2013 16:08, Alexandre Belloni wrote:
> As per the datasheets, maximum battery regulation voltage is 4440mV.
>
> The formula is (voltage - offset) / step, so the maximum value is:
> (4440 - 3500) / 20 = 47
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/power/bq2415x_charger.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
> index 0727f92..df893dd 100644
> --- a/drivers/power/bq2415x_charger.c
> +++ b/drivers/power/bq2415x_charger.c
> @@ -605,9 +605,13 @@ static int bq2415x_set_battery_regulation_voltage(struct bq2415x_device *bq,
>  {
>  	int val = (mV/10 - 350) / 2;
>  
> +	/*
> +	 * According to datasheet, maximum battery regulation voltage is
> +	 * 4440mV which is b101111 = 47.
> +	 */
>  	if (val < 0)
>  		val = 0;
> -	else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max value ? */
> +	else if (val > 47)
>  		return -EINVAL;
>  
>  	return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

