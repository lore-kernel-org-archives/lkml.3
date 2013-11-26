Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3KZPGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:06:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab3KZPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:06:20 -0500
Message-ID: <5294B8C4.6040803@ti.com>
Date: Tue, 26 Nov 2013 10:05:40 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/12] memory: davinci-aemif: introduce AEMIF driver
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-8-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D2E@DNCE04.ent.ti.com> <52944BD3.90105@ti.com>
In-Reply-To: <52944BD3.90105@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 November 2013 02:20 AM, Sekhar Nori wrote:
> On Monday 11 November 2013 10:36 PM, Khoronzhuk, Ivan wrote:
>> Add new AEMIF driver for EMIF16 davinci controller. The EMIF16 module
>> is intended to provide a glue-less interface to a variety of
>> asynchronous memory devices like ASRA M, NOR and NAND memory. A total
>> of 256M bytes of any of these memories can be accessed at any given
>> time via four chip selects with 64M byte access per chip select.
>>
>> Synchronous memories such as DDR1 SD RAM, SDR SDRAM and Mobile SDR
>> are not supported.
>>
>> See http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---

[...]

>> +static int davinci_aemif_probe(struct platform_device *pdev)
>> +{
>> +       int ret  = -ENODEV, i;
>> +       struct resource *res;
>> +       struct device *dev = &pdev->dev;
>> +       struct device_node *np = dev->of_node;
>> +
>> +       if (np == NULL)
>> +               return 0;
>> +
>> +       if (aemif) {
>> +               dev_err(dev, "davinci_aemif driver is in use currently\n");
>> +               return -EBUSY;
>> +       }
> 
> Why expressly prevent multiple AEMIF devices? Its entirely conceivable
> to have two memories like NAND and NOR flash connect to two different
> AEMIF interfaces.
> 
Ivan wanted me to clarify the Keystone hardware which supports
1 instance of controller with 4 CS. That allows already four
devices to be connected. Currently NAND and NOR are connected on it
and two more slots are free.

Since driver support what hardware is, lets not build a driver for
hardware which don't exist. And if at all such a support would be
needed in future, we can always add it.

Regards,
Santosh


