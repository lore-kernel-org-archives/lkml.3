Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbbARJOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 04:14:14 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:7546 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbARJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 04:14:10 -0500
X-IronPort-AV: E=Sophos;i="5.09,420,1418112000"; 
   d="scan'208";a="55044341"
Message-ID: <54BB795C.6040402@broadcom.com>
Date: Sun, 18 Jan 2015 10:14:04 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ray Jui <rjui@broadcom.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <Ray Jui <rjui@broadcom.com> <1421451737-7107-1-git-send-email-rjui@broadcom.com> <1421451737-7107-3-git-send-email-rjui@broadcom.com>
In-Reply-To: <1421451737-7107-3-git-send-email-rjui@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/15 00:42, Ray Jui wrote:

[...]

> +/*
> + * Can be expanded in the future if more interrupt status bits are utilized
> + */
> +#define ISR_MASK (1<<  IS_M_START_BUSY_SHIFT)
> +
> +static irqreturn_t bcm_iproc_i2c_isr(int irq, void *data)
> +{
> +	struct bcm_iproc_i2c_dev *iproc_i2c = data;
> +	u32 status = readl(iproc_i2c->base + IS_OFFSET);
> +
> +	status&= ISR_MASK;
> +
> +	if (!status)
> +		return IRQ_NONE;
> +
> +	writel(status, iproc_i2c->base + IS_OFFSET);
> +	complete_all(&iproc_i2c->done);

Looking over this code it seems to me there is always a single process 
waiting for iproc_i2c->done to complete. So using complete() here would 
suffice.

Regards,
Arend

> +
> +	return IRQ_HANDLED;
> +}

