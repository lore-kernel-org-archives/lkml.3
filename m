Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaI1CQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:16:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:48106 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaI1CQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:16:41 -0400
Message-ID: <54276F6C.5010705@huawei.com>
Date: Sun, 28 Sep 2014 10:16:12 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <liviu@dudau.co.uk>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 00/22] Use MSI chip framework to configure MSI/MSI-X
 in all platforms
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com> <20140925074235.GN12423@ulmo> <20140925144855.GB31157@bart.dudau.co.uk> <20140925164937.GB30382@ulmo> <5424E09F.50701@huawei.com> <20140926085030.GE31157@bart.dudau.co.uk>
In-Reply-To: <20140926085030.GE31157@bart.dudau.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54276F86.009F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: bc7a0eef4c8aa463ce41e250f24a1d40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> What I would like to see is a way of creating the pci_host_bridge structure outside
>>>> the pci_create_root_bus(). That would then allow us to pass this sort of platform
>>>> details like associated msi_chip into the host bridge and the child busses will
>>>> have an easy way of finding the information needed by finding the root bus and then
>>>> the host bridge structure. Then the generic pci_scan_root_bus() can be used by (mostly)
>>>> everyone and the drivers can remove their kludges that try to work around the
>>>> current limitations.
>>
>> So I think maybe save msi chip in PCI arch sysdata is a good candidate.
> 
> Except that arch sysdata at the moment is an opaque pointer. I am all in favour in
> changing the type of sysdata from void* into pci_host_bridge* and arches can wrap their old
> sysdata around the pci_host_bridge*.

I inspected every arch and found there are almost no common stuff, and generic data struct should
be created in generic PCI code. Another, I don't like associate msi chip and every PCI device, further more,
almost all platforms except arm have only one MSI controller, and currently, PCI enumerating code doesn't need
to know the MSI chip details, like for legacy IRQ, PCI device doesn't need to know which IRQ controller they
should deliver IRQ to. I would think more about it, and hope other PCI guys can give some comments, especially from Bjorn.

Thanks!
Yijing.

> 
> Best regards,
> Liviu
> 
>>
>>>
>>> I think both issues are orthogonal. Last time I checked a lot of work
>>> was still necessary to unify host bridges enough so that it could be
>>> shared across architectures. But perhaps some of that work has
>>> happened in the meantime.
>>>
>>> But like I said, when you create the root bus, you can easily attach the
>>> MSI chip to it.
>>>
>>> Thierry
>>>
>>
>>
>> -- 
>> Thanks!
>> Yijing
>>
>>
> 


-- 
Thanks!
Yijing

