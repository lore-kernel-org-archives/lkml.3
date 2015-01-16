Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbAPWwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:52:42 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:5625 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbAPWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:52:40 -0500
X-IronPort-AV: E=Sophos;i="5.09,413,1418112000"; 
   d="scan'208";a="55171043"
Message-ID: <54B99635.3090905@broadcom.com>
Date: Fri, 16 Jan 2015 14:52:37 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        =?windows-1252?Q?Uwe_Kleine-K=F6n?= =?windows-1252?Q?ig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        "Matt Porter" <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <rjui@broadcom.com> <1421274213-3544-1-git-send-email-rjui@broadcom.com> <1421274213-3544-3-git-send-email-rjui@broadcom.com> <20150115084119.GN22880@pengutronix.de> <20150115120704.GB2549@katana>
In-Reply-To: <20150115120704.GB2549@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/15/2015 4:07 AM, Wolfram Sang wrote:
>>> +static int bcm_iproc_i2c_remove(struct platform_device *pdev)
>>> +{
>>> +	struct bcm_iproc_i2c_dev *iproc_i2c = platform_get_drvdata(pdev);
>>> +
>>> +	i2c_del_adapter(&iproc_i2c->adapter);
>> You need to free the irq before i2c_del_adapter.
> 
> One could also keep using devm_request_irq and disable all interrupts
> sources here?
> 
Okay this makes sense. Will use devm_request_irq and disable interrupt
in the remove function. Thanks.

> Thanks for the reviews, Uwe!
> 
>    Wolfram
> 
