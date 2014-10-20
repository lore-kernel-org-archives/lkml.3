Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaJTSPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:15:47 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43455 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaJTSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:15:44 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] i2c/at91: add support for system PM
References: <1413776535-10123-1-git-send-email-wenyou.yang@atmel.com>
	<1413776535-10123-3-git-send-email-wenyou.yang@atmel.com>
Date: Mon, 20 Oct 2014 11:15:41 -0700
In-Reply-To: <1413776535-10123-3-git-send-email-wenyou.yang@atmel.com> (Wenyou
	Yang's message of "Mon, 20 Oct 2014 11:42:13 +0800")
Message-ID: <7h8ukafvzm.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wenyou Yang <wenyou.yang@atmel.com> writes:

Add a changelog here describing what you're doing, and why.

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  drivers/i2c/busses/i2c-at91.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 03b9f48..8f408f8 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -845,6 +845,35 @@ static int at91_twi_remove(struct platform_device *pdev)
>  }
>  
>  #ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
> +static int at91_twi_suspend(struct device *dev)
> +{
> +	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> +
> +	if (!pm_runtime_suspended(dev))
> +		clk_disable_unprepare(twi_dev->clk);

I would just call at91_twi_runtime_suspend() here.

Then, if you need to add additional steps, you only have to add them in
once place.  This also makes it obvious that ->suspend and
->runtime_suspend are doing the exact same thing.

NOTE: you'll need to wrap the runtime_suspend|resume functions in just
CONFIG_PM instead of CONFIG_PM_RUNTIME for this to work.

Kevin
