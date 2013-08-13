Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3HMJYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:24:06 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49309 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3HMJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:24:04 -0400
Message-ID: <5209FB2E.5020808@gmail.com>
Date: Tue, 13 Aug 2013 11:23:58 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/9] PCI: mvebu: increment nports only for registered
 ports
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-3-git-send-email-sebastian.hesselbarth@gmail.com> <20130813091539.20d4b6a3@skate>
In-Reply-To: <20130813091539.20d4b6a3@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/13 09:15, Thomas Petazzoni wrote:
> Dear Sebastian Hesselbarth,
>
> On Mon, 12 Aug 2013 20:46:48 +0200, Sebastian Hesselbarth wrote:
>
>> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
>> index d5fe674..0a359d7 100644
>> --- a/drivers/pci/host/pci-mvebu.c
>> +++ b/drivers/pci/host/pci-mvebu.c
>> @@ -842,21 +842,21 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
>>   		return ret;
>>   	}
>>
>> +	i = 0;
>>   	for_each_child_of_node(pdev->dev.of_node, child) {
>>   		if (!of_device_is_available(child))
>>   			continue;
>> -		pcie->nports++;
>> +		i++;
>>   	}
>>
>> -	pcie->ports = devm_kzalloc(&pdev->dev, pcie->nports *
>> +	pcie->ports = devm_kzalloc(&pdev->dev, i *
>>   				   sizeof(struct mvebu_pcie_port),
>>   				   GFP_KERNEL);
>>   	if (!pcie->ports)
>>   		return -ENOMEM;
>>
>> -	i = 0;
>>   	for_each_child_of_node(pdev->dev.of_node, child) {
>> -		struct mvebu_pcie_port *port = &pcie->ports[i];
>> +		struct mvebu_pcie_port *port = &pcie->ports[pcie->nports];
>>
>>   		if (!of_device_is_available(child))
>>   			continue;
>> @@ -929,7 +929,7 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
>>   		port->dn = child;
>>   		spin_lock_init(&port->conf_lock);
>>   		mvebu_sw_pci_bridge_init(port);
>> -		i++;
>> +		pcie->nports++;
>>   	}
>
> I think I'd prefer using 'i' in this loop, and then after the loop have
> a:
>
> 	pcie->nports = i;
>
> assignment. That's nitpicking, but I don't like the fact that within
> the loop 'pcie->nports' doesn't mean "Number of enabled PCIe ports",
> but means "Last enabled PCIe port".

Ok, I'll use 'i' in both loops and assign it like you suggested.

Sebastian
