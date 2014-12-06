Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaLFLPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 06:15:48 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60495 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaLFLPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 06:15:47 -0500
Message-ID: <5482E560.2090707@kernel.org>
Date: Sat, 06 Dec 2014 11:15:44 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] iio: accel: kxcjk-1013: always power on device in
 resume
References: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com> <1417817890-10252-2-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1417817890-10252-2-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 22:18, Irina Tirdea wrote:
> When the system resumes, it will first call system resume and
> then runtime suspend (if CONFIG_RUNTIME_PM is enabled).
> There is no need to conditionally power on the device in
> system resume, so always power it on and leave runtime
> suspend to power it off if needed.
> 
> Suggested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the togreg branch of iio.git

Thanks,
> ---
>  drivers/iio/accel/kxcjk-1013.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 1720e9a..aed3777 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -1354,10 +1354,7 @@ static int kxcjk1013_resume(struct device *dev)
>  	int ret = 0;
>  
>  	mutex_lock(&data->mutex);
> -	/* Check, if the suspend occured while active */
> -	if (data->dready_trigger_on || data->motion_trigger_on ||
> -							data->ev_enable_state)
> -		ret = kxcjk1013_set_mode(data, OPERATION);
> +	ret = kxcjk1013_set_mode(data, OPERATION);
>  	mutex_unlock(&data->mutex);
>  
>  	return ret;
> 

