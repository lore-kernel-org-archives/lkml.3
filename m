Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaKXTWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:22:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38690 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaKXTWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:22:51 -0500
Message-ID: <54738570.8070601@ti.com>
Date: Mon, 24 Nov 2014 21:22:24 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Looijmans <info@milosoftware.com>,
        =?windows-1252?Q?Uwe_Kleine?= =?windows-1252?Q?-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus
 recovery
References: <1416477788-5544-6-git-send-email-grygorii.strashko@ti.com> <20141123170400.GC4431@pengutronix.de> <54732F8E.4080105@ti.com> <54737532.1050808@milosoftware.com>
In-Reply-To: <54737532.1050808@milosoftware.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 08:13 PM, Mike Looijmans wrote:
> On 24-11-2014 14:15, Grygorii Strashko wrote:
>> Hi Uwe,
>> On 11/23/2014 07:04 PM, Uwe Kleine-König wrote:
>>> On Thu, Nov 20, 2014 at 12:03:08PM +0200, Grygorii Strashko wrote:
>>>> @@ -664,6 +759,7 @@ static int davinci_i2c_probe(struct 
>>>> platform_device *pdev)
>>>>            if (!of_property_read_u32(pdev->dev.of_node, 
>>>> "clock-frequency",
>>>>                &prop))
>>>>                dev->pdata->bus_freq = prop / 1000;
>>>> +        dev->pdata->has_pfunc = true;
>>> I don't understand this. Why does this ICPFUNC recovery work if the bus
>>> is probed by oftree, but doesn't if not?
>> I've mentioned this in commit message:
>>   Allow platforms to indicate the presence of the ICPFUNC registers 
>> with a has_pfunc
>>   platform data flag and enable this mode for platforms which supports 
>> DT (da850 and
>>   Keystone 2 are two SoCs which support DT now and they also support 
>> ICPFUNC registers).
>>
>> I'll add proper comment here.
> 
> Just thinking: What happens if you try to use the ICPFUNC registers on 
> platforms that don't support it? If the answer is "nothing bad", then 
> you might as well assume that if the platform doesn't specify its own 
> GPIOs, you can always try using the ICPFUNC registers to shake the I2C 
> bus. Better to try and fail than to never try at all...
> 

I think the right answer is !"nothing bad".

My intention was to enable this feature by default, because current DT-compatible
SoCs support it and the possibility that older SoCs will migrate to DT is low.
But now I think that the right way will be to add proper compatible strings
and use them to detect if ICPFUNC registers are supported or not.

[...]

regards,
-grygorii
