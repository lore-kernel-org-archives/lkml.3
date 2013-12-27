Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3L0IiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 03:38:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43035 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3L0IiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 03:38:03 -0500
Message-ID: <52BD3C2F.9010409@ti.com>
Date: Fri, 27 Dec 2013 14:07:03 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <robherring2@gmail.com>, <tglx@linutronix.de>,
        <galak@codeaurora.org>, <rob.herring@calxeda.com>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH V5 2/4] DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar
 IP
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com> <1386066445-28245-3-git-send-email-r.sricharan@ti.com> <20131226200106.GA30559@saruman.home>
In-Reply-To: <20131226200106.GA30559@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Friday 27 December 2013 01:31 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Dec 03, 2013 at 03:57:23PM +0530, Sricharan R wrote:
>> +static const struct of_device_id crossbar_match[] __initconst = {
>> +	{ .compatible = "ti,irq-crossbar" },
>> +	{}
>> +};
>> +
>> +int irqcrossbar_init(void)
>> +{
>> +	struct device_node *np;
>> +	np = of_find_matching_node(NULL, crossbar_match);
>> +	if (!np)
>> +		return -ENODEV;
>> +
>> +	crossbar_of_init(np);
>> +	return 0;
>> +}
> 
> instead, please use IRQCHIP_DECLARE() then you won't need to expose this
> symbol to be used by arch/arm/ code.
> 

Crossbar node does not have a "interrupt-controller" property and
not a regular Interrupt controller. This was added in here
after all below discussions

 https://lkml.org/lkml/2013/9/18/540

So IRQCHIP_DECLARE() macro cannot be used here.

Regards,
 Sricharan
