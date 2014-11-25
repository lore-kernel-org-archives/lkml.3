Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaKYNE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:04:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36641 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaKYNEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:04:54 -0500
Message-ID: <54747E5E.8070204@ti.com>
Date: Tue, 25 Nov 2014 15:04:30 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
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
References: <1416477788-5544-6-git-send-email-grygorii.strashko@ti.com> <20141123170400.GC4431@pengutronix.de> <54732F8E.4080105@ti.com> <20141124194533.GU4431@pengutronix.de>
In-Reply-To: <20141124194533.GU4431@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,
On 11/24/2014 09:45 PM, Uwe Kleine-König wrote:
> On Mon, Nov 24, 2014 at 03:15:58PM +0200, Grygorii Strashko wrote:
>> On 11/23/2014 07:04 PM, Uwe Kleine-König wrote:
>>> On Thu, Nov 20, 2014 at 12:03:08PM +0200, Grygorii Strashko wrote:
>>>> @@ -664,6 +759,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
>>>>    		if (!of_property_read_u32(pdev->dev.of_node, "clock-frequency",
>>>>    			&prop))
>>>>    			dev->pdata->bus_freq = prop / 1000;
>>>> +		dev->pdata->has_pfunc = true;
>>> I don't understand this. Why does this ICPFUNC recovery work if the bus
>>> is probed by oftree, but doesn't if not?
>>
>> I've mentioned this in commit message:
>>   Allow platforms to indicate the presence of the ICPFUNC registers with a has_pfunc
>>   platform data flag and enable this mode for platforms which supports DT (da850 and
>>   Keystone 2 are two SoCs which support DT now and they also support ICPFUNC registers).
> Ah, so you assume that in the dt case the pfunc functionality is
> available. I didn't understand if it's bad or not if this assumption is
> wrong, but I suggest to only use the pfunc stuff if the device node has
> a given property (e.g. ti,has_pfunc).

Agree. I'll add it.

regards,
-grygorii
