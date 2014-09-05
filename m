Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaIESeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:34:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48912 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaIESeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:34:12 -0400
Message-ID: <540A0212.6060303@ti.com>
Date: Fri, 5 Sep 2014 14:33:54 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: update to support multiple pci ports
References: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com> <7260053.FoBVhTXVfj@wuerfel>
In-Reply-To: <7260053.FoBVhTXVfj@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:54 PM, Arnd Bergmann wrote:
> On Friday 05 September 2014 13:39:42 Murali Karicheri wrote:
>> +
>>          /* enable RC mode in devcfg */
>>          val = readl(reg_p);
>> -       val&= ~PCIE_MODE_MASK;
>> -       val |= PCIE_RC_MODE;
>> +       port_id<<= 1;
>> +       val&= ~(PCIE_MODE_MASK<<  port_id);
>> +       val |= (PCIE_RC_MODE<<  port_id);
>>          writel(val, reg_p);
>> +       devm_iounmap(dev, reg_p);
>> +       devm_release_mem_region(dev, res->start, resource_size(res));
>
> This looks like it's a shared register of some sort that doesn't
> really belong into the registers of a particular port. Could it
> be that it's actually for the PHY?
>
> 	Arnd
Arnd,

This a shared device configuration register between the two ports the 
desciption states it is bootstrap configuration of the PCIe module as 
Endpoint or Root complex and Not Phy. Hope below text will help.

Table 3-23 Device Configuration Register (DEVCFG)


PCIESSMODE[1:0] 00b PCIESSMODE is used to control the
functionality of PCIESS module out of
reset. This MMR output is connected to
DEVTYPE input of PCIESS
(Changes from
Nysh) : Note that in Nysh this value came
from a bootstrap pin.
00 : Endpoint
01 : Legacy Endpoint
10 : Rootcomplex
11 : Reserved
PCIESS_1_MODE[1:0
]
00b PCIESSMODE is used to control the
functionality of PCIE_1 module out of
reset. This MMR output is connected to
DEVTYPE input of PCIE_1
00 : Endpoint
01 : Legacy Endpoint
10 : Rootcomplex
11 : Reserv

