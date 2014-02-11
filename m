Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaBKBz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:55:26 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:33652 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBKBzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:55:25 -0500
Message-ID: <52F982FF.2070007@huawei.com>
Date: Tue, 11 Feb 2014 09:55:11 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Paul Bolle <pebolle@tiscali.nl>, "RafaelJ.Wysocki" <rjw@rjwysocki.net>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH part1 v5 3/7] PCI: Add support for Device Serial Number
 capability
References: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>	 <1392005051-54508-4-git-send-email-wangyijing@huawei.com> <1392027718.2082.11.camel@linux-fkkt.site>
In-Reply-To: <1392027718.2082.11.camel@linux-fkkt.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/10 18:21, Oliver Neukum wrote:
> 
> On Mon, 2014-02-10 at 12:04 +0800, Yijing Wang wrote:
>> +static u64 pci_device_serial_number(struct pci_bus *bus, int devfn)
>> +{
>> +       int pos;
>> +       u32 lo, hi;
>> +
>> +       if (!pci_bus_find_capability(bus, devfn, PCI_CAP_ID_EXP))
>> +               return 0;
>> +
>> +       pos = pci_bus_find_ext_capability(bus, devfn,
>> PCI_EXT_CAP_ID_DSN);
>> +       if (!pos)
>> +               return 0;
>> +
>> +       pci_bus_read_config_dword(bus, devfn, pos + 4, &lo);
>> +       pci_bus_read_config_dword(bus, devfn, pos + 8, &hi);
> 
> We have no macro for that?

Yes, I will try to define macros for them, thanks!

> 
>> +       return ((u64)hi << 32) | lo;
>> +}
> 
> 	Regards
> 		Oliver
> 
> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

