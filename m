Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaHECV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:21:29 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:20668 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHECV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:21:27 -0400
Message-ID: <53E03F87.8040702@huawei.com>
Date: Tue, 5 Aug 2014 10:20:55 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jiang Liu <jiang.liu@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <Paul.Mundt@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>,
        <linux-pci@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        <virtualization@lists.linux-foundation.org>,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <201408011516.26253.arnd@arndb.de> <53DEFECB.3030201@huawei.com> <201408041645.50566.arnd@arndb.de>
In-Reply-To: <201408041645.50566.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53E03F97.002D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 0933722c5f04936e103810e26ab3ed3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/4 22:45, Arnd Bergmann wrote:
> On Monday 04 August 2014, Yijing Wang wrote:
>> I have another question is some drivers will request more than one
>> MSI/MSI-X IRQ, and the driver will use them to process different things.
>> Eg. network driver generally uses one of them to process trivial network thins,
>> and others to transmit/receive data.
>>
>> So, in this case, it seems to driver need to touch the IRQ numbers.
>>
>> wr-linux:~ # cat /proc/interrupts
>>             CPU0       CPU1       CPU2     ....      CPU17      CPU18      CPU19      CPU20      CPU21      CPU22      CPU23
>>  ......
>>  100:          0          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0
>>  101:          2          0          0               0          0          0  302830488          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-0
>>  102:        110          0          0               0          0  360675897          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-1
>>  103:        109          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-2
>>  104:        107          0          0         9678933          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-3
>>  105:        107          0          0               0  357838258          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-4
>>  106:        115          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-5
>>  107:        114          0          0               0          0          0          0  337866096          0          0  IR-PCI-MSI-edge      eth0-TxRx-6
>>  108:  373801199          0          0               0          0          0          0          0          0          0  IR-PCI-MSI-edge      eth0-TxRx-7
>>
> 
> I think in this example, you just need to request eight interrupts, and pass a
> different data pointer each time, pointing to the napi_struct of each of the
> NIC queues. The driver has no need to deal with the IRQ number at all,
> and I would be surprised if it cared today.

Yes, you are right, this is not a stumbling block. :)

> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing

