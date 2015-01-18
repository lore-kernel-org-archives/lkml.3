Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbbARAal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:30:41 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:9582 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbARAag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:30:36 -0500
X-IronPort-AV: E=Sophos;i="5.09,419,1418112000"; 
   d="scan'208";a="55037129"
Message-ID: <54BAFEA9.9040900@broadcom.com>
Date: Sat, 17 Jan 2015 16:30:33 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robh+dt@kernel.org>,
        "Pawel Moll" <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <1421274213-3544-1-git-send-email-rjui@broadcom.com> <1421274213-3544-3-git-send-email-rjui@broadcom.com> <20150115084119.GN22880@pengutronix.de> <54B98C18.4080807@broadcom.com> <20150117160113.GA22880@pengutronix.de> <54BABEE9.8070801@broadcom.com> <20150117201849.GC22880@pengutronix.de> <54BACB66.6040909@broadcom.com> <20150117211017.GD22880@pengutronix.de> <54BAD391.9080909@broadcom.com> <20150117224021.GA26493@n2100.arm.linux.org.uk>
In-Reply-To: <20150117224021.GA26493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/17/2015 2:40 PM, Russell King - ARM Linux wrote:
> On Sat, Jan 17, 2015 at 01:26:41PM -0800, Ray Jui wrote:
>> 	time_left = wait_for_completion_timeout(&iproc_i2c->done, time_left);
>>
>> 	/* disable all interrupts */
>> 	writel(0, iproc_i2c->base + IE_OFFSET);
>>
>> 	if (!time_left && !atomic_read(&iproc_i2c->transfer_is_successful)) {
> 
> Why are you using atomic_read() here?
> 
transfer_is_successful 1) will be reset to 0 in this function (before
kick start the I2C transfer), 2) will be set to 1 in the ISR (to signal
completion of the I2C transfer), and 3) will be checked in this function
here. I thought that means I should declare it volatile, because it can
be modified in both the process context and interrupt context (and I use
atomic because I remember Linux checkpatch warns against using volatile)?
