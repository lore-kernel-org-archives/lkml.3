Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaJBWiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 18:38:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58022 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaJBWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 18:38:20 -0400
Message-ID: <542DD3DA.1010909@codeaurora.org>
Date: Thu, 02 Oct 2014 15:38:18 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC 5/7] soc: qcom: Add Shared Memory Driver
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com> <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1412037291-16880-6-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/14 17:34, Bjorn Andersson wrote:
> +
> +#define GET_RX_CHANNEL_INFO(channel, param) \
> +	(channel->rx_info_word ? \
> +		channel->rx_info_word->param : \
> +		channel->rx_info->param)
> +
> +#define GET_TX_CHANNEL_INFO(channel, param) \
> +	(channel->rx_info_word ? \
> +		channel->tx_info_word->param : \
> +		channel->tx_info->param)
> +
> +#define SET_RX_CHANNEL_INFO(channel, param, value) \
> +	(channel->rx_info_word ? \
> +		(channel->rx_info_word->param = value) : \
> +		(channel->rx_info->param = value))
> +
> +#define SET_TX_CHANNEL_INFO(channel, param, value) \
> +	(channel->rx_info_word ? \

Drive-by review: Should this be tx_info_word? Given that it works I
wonder why not just have a flag indicating if we should use word aligned
read/write vs. byte aligned.

> +		(channel->tx_info_word->param = value) : \
> +		(channel->tx_info->param = value))
> +


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

