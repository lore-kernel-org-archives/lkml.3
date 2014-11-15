Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaKOQNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 11:13:30 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42853 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaKOQN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 11:13:28 -0500
Message-ID: <54677BA6.1030205@kernel.org>
Date: Sat, 15 Nov 2014 16:13:26 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: srinivas.pandruvada@linux.intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: accel: kxcjk-1013: Fix kxcjk10013_set_range
References: <1415607616-17215-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1415607616-17215-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/14 08:20, Daniel Baluta wrote:
> Currently, we get the new GSEL bits by OR-ing the old values
> with the new ones. This only works first time when the old
> values are 0.
> 
> Startup:
> 	* GSEL0 = 0, GSEL1 = 0
> 
> Set range to 4G: (GSEL0 = 1, GSEL1 = 0)
> 	* GSEL0 = 0 | 1 = 1
> 	* GSEL1 = 0 | 0 = 0
> 	* correct
> 
> Change range to 2G: (GSEL0 = 0, GSEL1 = 0)
> 	* GSEL0 = 1 | 0 = 1
> 	* GSEL1 = 0 | 0 = 0
> 	* wrong, GSEL0 should be 0
> 
> This has the nice effect that we can use the full scale range,
> exported in in_accel_scale_available.
> 
> Fixes: a735e3d7f03 (iio: accel: kxcjk-1013: Set adjustable range)
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the fixes-togreg branch of iio.git and marked for stable.
Thanks,

> ---
>  drivers/iio/accel/kxcjk-1013.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 98909a9..21f1279 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -269,6 +269,8 @@ static int kxcjk1013_set_range(struct kxcjk1013_data *data, int range_index)
>  		return ret;
>  	}
>  
> +	ret &= ~(KXCJK1013_REG_CTRL1_BIT_GSEL0 |
> +		 KXCJK1013_REG_CTRL1_BIT_GSEL1);
>  	ret |= (KXCJK1013_scale_table[range_index].gsel_0 << 3);
>  	ret |= (KXCJK1013_scale_table[range_index].gsel_1 << 4);
>  
> 

