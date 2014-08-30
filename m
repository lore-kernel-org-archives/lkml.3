Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaH3K3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:29:10 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60775 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaH3K3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:29:08 -0400
Message-ID: <5401A770.3040204@kernel.org>
Date: Sat, 30 Aug 2014 11:29:04 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: handle -EPROBE_DEFER in of_iio_channel_get_by_name
References: <4420839.L1RSpT2Pjo@diego>
In-Reply-To: <4420839.L1RSpT2Pjo@diego>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/14 23:13, Heiko Stübner wrote:
> Till now of_iio_channel_get_by_name always tried to find the channel without
> evaluating the return code from of_iio_channel_get. This might include
> -EPROBE_DEFER in which case the channel is present but its driver simply not
> probed yet. Therefore simply return on -EPROBE_DEFER so that the driver
> requesting the channel can also defer.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
I already have a patch queued up for this change in the fixes-togreg branch

[PATCH] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name by Johannes Pointner

I'm just being a little slow catching up with patches at the moment.

J
> ---
>  drivers/iio/inkern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index c749700..f084610 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -178,7 +178,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
>  			index = of_property_match_string(np, "io-channel-names",
>  							 name);
>  		chan = of_iio_channel_get(np, index);
> -		if (!IS_ERR(chan))
> +		if (!IS_ERR(chan) || PTR_ERR(chan) == -EPROBE_DEFER)
>  			break;
>  		else if (name && index >= 0) {
>  			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
> 
