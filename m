Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbbADLRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 06:17:04 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48329 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbADLRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 06:17:01 -0500
Message-ID: <54A9212B.8050709@kernel.org>
Date: Sun, 04 Jan 2015 11:16:59 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC] iio: iadc: wait_for_completion_timeout time in jiffies
References: <1420016386-19638-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1420016386-19638-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/12/14 08:59, Nicholas Mc Guire wrote:
> The timeout value to wait_for_completion_timeout is in jiffies but
> the value being passed seems like it was intended to by microseconds
> Note that the timeout was extremely long thus it might be too short
> now. In any case it probably should be passed through usecs_to_jiffies()
> or msecs_to_jiffies()
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> 
> patch was only compile-tested x86_64_defcofnig + CONFIG_SPMI=m
> CONFIG_IIO=m, CONFIG_QCOM_SPMI_IADC=m
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Certainly suspicious and I'd draw the same conclusion you did!
Anyhow just waiting for Ivan to take a look as it's his driver.

Thanks,

Jonathan
> ---
>  drivers/iio/adc/qcom-spmi-iadc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
> index b9666f2..3080562 100644
> --- a/drivers/iio/adc/qcom-spmi-iadc.c
> +++ b/drivers/iio/adc/qcom-spmi-iadc.c
> @@ -296,7 +296,8 @@ static int iadc_do_conversion(struct iadc_chip *iadc, int chan, u16 *data)
>  	if (iadc->poll_eoc) {
>  		ret = iadc_poll_wait_eoc(iadc, wait);
>  	} else {
> -		ret = wait_for_completion_timeout(&iadc->complete, wait);
> +		ret = wait_for_completion_timeout(&iadc->complete,
> +			usecs_to_jiffies(wait));
>  		if (!ret)
>  			ret = -ETIMEDOUT;
>  		else
> 

