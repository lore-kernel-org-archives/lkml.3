Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3K0KXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:23:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37916 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3K0KX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:23:29 -0500
Message-ID: <5295C7D3.8010803@ti.com>
Date: Wed, 27 Nov 2013 12:22:11 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/12] memory: davinci-aemif: introduce AEMIF driver
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com> <1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com> <52944BD3.90105@ti.com> <5294B8C4.6040803@ti.com> <5294D8AD.5030106@ti.com> <5294E7E4.3060600@ti.com> <20131127003707.GQ9468@ld-irv-0074.broadcom.com>
In-Reply-To: <20131127003707.GQ9468@ld-irv-0074.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 02:37 AM, Brian Norris wrote:
> On Tue, Nov 26, 2013 at 01:26:44PM -0500, Santosh Shilimkar wrote:
>> On Tuesday 26 November 2013 12:21 PM, Sekhar Nori wrote:
>>> On 11/26/2013 8:35 PM, Santosh Shilimkar wrote:
>>>> On Tuesday 26 November 2013 02:20 AM, Sekhar Nori wrote:
>>>>> On Monday 11 November 2013 10:36 PM, Khoronzhuk, Ivan wrote:
>>>>>> +static int davinci_aemif_probe(struct platform_device *pdev)
>>>>>> +{
>>>>>> +       int ret  = -ENODEV, i;
>>>>>> +       struct resource *res;
>>>>>> +       struct device *dev = &pdev->dev;
>>>>>> +       struct device_node *np = dev->of_node;
>>>>>> +
>>>>>> +       if (np == NULL)
>>>>>> +               return 0;
>>>>>> +
>>>>>> +       if (aemif) {
>>>>>> +               dev_err(dev, "davinci_aemif driver is in use currently\n");
>>>>>> +               return -EBUSY;
>>>>>> +       }
>>>>>
>>>>> Why expressly prevent multiple AEMIF devices? Its entirely conceivable
>>>>> to have two memories like NAND and NOR flash connect to two different
>>>>> AEMIF interfaces.
>>>>>
>>>> Ivan wanted me to clarify the Keystone hardware which supports
>>>> 1 instance of controller with 4 CS. That allows already four
>>>> devices to be connected. Currently NAND and NOR are connected on it
>>>> and two more slots are free.
>>>>
>>>> Since driver support what hardware is, lets not build a driver for
>>>> hardware which don't exist. And if at all such a support would be
>>>> needed in future, we can always add it.
>>>
>>> I understand the lack of hardware part, but its common to write the
>>> driver such that it can handle multiple instances. Is there any gain on
>>> current hardware because of this check? From what I am hearing, the code
>>> in question wont be exercised at all. So why go all the way and add it
>>> in first place?
>>>
>> Fair enough. The check can be dropped.
>
> Hmm, while the sentiment expressed by Sekhar is noble (to avoid
> unnecessarily constraining the driver), removing the check is not
> enough. You're still using a global static variable 'aemif', and it is
> important not to accidentally re-use this struct if a second device ever
> becomes available. So for the current implementation, the check is
> necessary IMO. If instead, you were to make 'aemif' a per-device struct
> (like with platform_set_drvdata()), then you would not have this issue.
>
> Brian
>

Yes, that is the plan to make it a per-device.

-- 
Regards,
Ivan Khoronzhuk
