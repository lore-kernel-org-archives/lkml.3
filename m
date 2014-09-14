Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaINRe0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:34:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55721 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaINReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:34:24 -0400
Message-ID: <5415D19E.9030105@kernel.org>
Date: Sun, 14 Sep 2014 18:34:22 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>
CC: pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: accel: kxcjk-1013: Fix defined but unused warning
References: <1409757192-17546-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1409757192-17546-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 16:13, Daniel Baluta wrote:
> Noticed when compiling with CONFIG_PM_RUNTIME not set:
> kxcjk-1013.c: warning: ‘kxcjk1013_get_startup_times’ defined but not used [-Wunused-function]
> 
> Introduced by commit 124e1b1d (iio: accel: kxcjk-1013: support runtime pm).
> 
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Note, convention is author first in this list then reviewers etc then sign offs from
those handling the patch.

Applied to the togreg branch of iio.git - initially pushed out as testing.

Thanks,

J
> ---
>  drivers/iio/accel/kxcjk-1013.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 736231d..eb1b8b6 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -307,6 +307,7 @@ static int kxcjk1013_chip_init(struct kxcjk1013_data *data)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
>  static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
>  {
>  	int i;
> @@ -318,6 +319,7 @@ static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
>  
>  	return KXCJK1013_MAX_STARTUP_TIME_US;
>  }
> +#endif
>  
>  static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
>  {
> 
