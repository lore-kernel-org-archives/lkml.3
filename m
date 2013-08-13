Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3HMJZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:25:41 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53826 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3HMJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:25:39 -0400
Message-ID: <5209FB8F.8000506@gmail.com>
Date: Tue, 13 Aug 2013 11:25:35 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/9] PCI: mvebu: remove subsys_initcall
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-4-git-send-email-sebastian.hesselbarth@gmail.com> <20130813091959.784b44f0@skate> <20130813080639.GD9316@ulmo>
In-Reply-To: <20130813080639.GD9316@ulmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/13 10:06, Thierry Reding wrote:
> On Tue, Aug 13, 2013 at 09:19:59AM +0200, Thomas Petazzoni wrote:
>> On Mon, 12 Aug 2013 20:46:49 +0200, Sebastian Hesselbarth wrote:
>>> This removes the subsys_initcall from the driver and converts it to
>>> a normal platform_driver. Also, drvdata is set and a remove functions
>>> is added to disable the clock and free resources.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>
>> I'm OK with this, just a comment below.
>>
>>> +static int mvebu_pcie_remove(struct platform_device *pdev)
>>> +{
>>> +	struct mvebu_pcie *pcie = platform_get_drvdata(pdev);
>>> +	struct mvebu_pcie_port *port = &pcie->ports[0];
>>> +	int i;
>>> +
>>> +	for (i = 0; i < pcie->nports; i++, port++) {
>>> +		clk_disable_unprepare(port->clk);
>>> +		kfree(port->name);
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> I believe the ->remove() part is quite useless. The driver is a 'bool'
>> in Kconfig, so it cannot be compiled as a module, and I'm not sure
>> there a way to remove the platform device that corresponds to the PCIe
>> controller.
>
> There is. You can write the device's name to the driver's unbind file in
> sysfs. What I ended up doing for Tegra was not to provide a .remove() at
> all and set the struct device_driver's .suppress_bind_attrs to true.
[...]
> That said, I agree with Thomas that it's not useful (and potentially
> even dangerous) to add the .remove() at this point in time.

Thierry, Thomas,

I will not introduce the .remove and set .suppress_bind_attrs = true as
Thierry suggested.

Sebastian

