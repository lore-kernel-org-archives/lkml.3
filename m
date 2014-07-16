Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541AbaGPRVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:21:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51116 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934726AbaGPRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:21:15 -0400
Message-ID: <53C6B489.3040001@codeaurora.org>
Date: Wed, 16 Jul 2014 10:21:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suman Tatiraju <sumant@codeaurora.org>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PM / devfreq: Allocate memory using the right data type
References: <1405480243-25915-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1405480243-25915-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 20:10, Saravana Kannan wrote:
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 65eed38..349e28ea 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -483,9 +483,10 @@ struct devfreq *devfreq_add_device(struct device *dev,
>  						devfreq->profile->max_state *
>  						devfreq->profile->max_state,
>  						GFP_KERNEL);
> -	devfreq->time_in_state = devm_kzalloc(dev, sizeof(unsigned int) *
> -						devfreq->profile->max_state,
> -						GFP_KERNEL);
> +	devfreq->time_in_state = devm_kzalloc(dev,
> +					sizeof(*(devfreq->time_in_state)) *
> +					devfreq->profile->max_state,
> +					GFP_KERNEL);

We could use devm_kcalloc() here too.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

