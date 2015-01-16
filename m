Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbAPWvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:51:17 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:45221 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbbAPWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:51:15 -0500
X-IronPort-AV: E=Sophos;i="5.09,413,1418112000"; 
   d="scan'208";a="55000183"
Message-ID: <54B995E0.8090406@broadcom.com>
Date: Fri, 16 Jan 2015 14:51:12 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
Subject: Re: [PATCH v3 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
References: <rjui@broadcom.com> <1418183832-24793-1-git-send-email-rjui@broadcom.com> <1418183832-24793-3-git-send-email-rjui@broadcom.com> <20150113225012.GK22880@pengutronix.de> <54B5D0F9.8030902@broadcom.com> <20150115115957.GA2549@katana>
In-Reply-To: <20150115115957.GA2549@katana>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/15/2015 3:59 AM, Wolfram Sang wrote:
>>>> +	case M_CMD_STATUS_LOST_ARB:
>>>> +		dev_err(dev->device, "lost bus arbitration\n");
>>> I wouldn't dev_err that, only dev_dbg. I'm not sure how usual the errors
>>> for the next two cases is, maybe degrade them to dev_dbg, too?
>>>
>> These errors are rare, and it's nice to keep them at the dev_err level
>> so the user will be more aware.
> 
> This is wrong. Arbitration lost and NACK is pretty standard stuff on an
> I2C bus. User doesn't need to know about it, it is just noise in the
> logs. Timeout is different, you can report that (although I should
> probably move such a message into the core). Please also use the proper
> errno codes defined in Documentation/i2c/fault-codes. They should be
> distinct enough to drop the messages.
> 
Okay will do.

>>
>>>> +		return -EREMOTEIO;
>>>> +
>>>> +	case M_CMD_STATUS_NACK_ADDR:
>>>> +		dev_err(dev->device, "NAK addr:0x%02x\n", dev->msg->addr);
>>>> +		return -EREMOTEIO;
>>>> +
>>>> +	case M_CMD_STATUS_NACK_DATA:
>>>> +		dev_err(dev->device, "NAK data\n");
>>>> +		return -EREMOTEIO;
>>>> +
>>>> +	case M_CMD_STATUS_TIMEOUT:
>>>> +		dev_err(dev->device, "bus timeout\n");
>>>> +		return -ETIMEDOUT;
>>>> +
>>>> +	default:
>>>> +		dev_err(dev->device, "unknown error code=%d\n", val);
>>>> +		return -EREMOTEIO;
>>>> +	}
>>>> +
>>>> +	return -EREMOTEIO;
>>>> +}
