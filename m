Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaLFLQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 06:16:15 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60498 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaLFLQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 06:16:14 -0500
Message-ID: <5482E57C.1030503@kernel.org>
Date: Sat, 06 Dec 2014 11:16:12 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] iio: accel: kxcjk-1013: only set power state if CONFIG_PM
 is defined
References: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com> <1417817890-10252-3-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1417817890-10252-3-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 22:18, Irina Tirdea wrote:
> When CONFIG_PM is not defined and the driver tries to power off the device,
> kxcjk1013_set_power_state will call pm_runtime_put_autosuspend, which is
> not implemented (wil return -ENOSYS).
> 
> Only call pm_runtime calls to change power state  when CONFIG_PM is defined.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the togreg branch of iio.git

Thanks
> ---
>  drivers/iio/accel/kxcjk-1013.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index aed3777..7b0a9da 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -376,6 +376,7 @@ static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
>  
>  static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
>  {
> +#ifdef CONFIG_PM
>  	int ret;
>  
>  	if (on)
> @@ -389,6 +390,7 @@ static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
>  			"Failed: kxcjk1013_set_power_state for %d\n", on);
>  		return ret;
>  	}
> +#endif
>  
>  	return 0;
>  }
> 

