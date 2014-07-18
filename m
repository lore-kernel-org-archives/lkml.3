Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422925AbaGRNvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:51:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60175 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422892AbaGRNvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:51:10 -0400
Message-ID: <53C92643.9050406@ti.com>
Date: Fri, 18 Jul 2014 09:50:59 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, <ivan.khoronzhuk@ti.com>,
        <m-karicheri2@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqchip: add keystone irq controller ip driver
References: <1405351677-12108-1-git-send-email-grygorii.strashko@ti.com> <20140718125953.GF24496@titan.lakedaemon.net>
In-Reply-To: <20140718125953.GF24496@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Friday 18 July 2014 08:59 AM, Jason Cooper wrote:
> Grygorii,
> 
> On Mon, Jul 14, 2014 at 06:27:57PM +0300, Grygorii Strashko wrote:
>> On Keystone SOCs, DSP cores can send interrupts to ARM
>> host using the IRQ controller IP. It provides 28 IRQ
>> signals to ARM. The IRQ handler running on HOST OS can
>> identify DSP signal source by analyzing SRCCx bits in
>> IPCARx registers. This is one of the component used by
>> the IPC mechanism used on Keystone SOCs.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>  .../interrupt-controller/ti,keystone-irq.txt       |   36 +++
>>  drivers/irqchip/Kconfig                            |    7 +
>>  drivers/irqchip/Makefile                           |    1 +
>>  drivers/irqchip/irq-keystone.c                     |  235 ++++++++++++++++++++
>>  4 files changed, 279 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
>>  create mode 100644 drivers/irqchip/irq-keystone.c
>>


[..]

>> +
>> +static const struct of_device_id keystone_irq_dt_ids[] = {
>> +	{ .compatible = "ti,keystone-irq", },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, keystone_irq_dt_ids);
>> +
>> +static struct platform_driver keystone_irq_device_driver = {
>> +	.probe		= keystone_irq_probe,
>> +	.remove		= keystone_irq_remove,
>> +	.driver		= {
>> +		.name	= "keystone_irq",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table	= of_match_ptr(keystone_irq_dt_ids),
>> +	}
>> +};
>> +
>> +module_platform_driver(keystone_irq_device_driver);
> 
> My understanding of DSP use-cases is a little sparse, are there
> legitimate scenarios where you might remove this driver during runtime?
> Perhaps IRQCHIP_DECLARE() might be better?
> 
There is no scenario where driver needs to hotpluged out. Usecase is
simple. Its really any other IRQCHIP. The difference is really the
source of interrupts. Instead of peripherals interrupting the host
OS9linux), here the DSP cores can send interrupts to Host OS.

Hope this clarifies.

Regards,
Santosh

