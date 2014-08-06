Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaHFBYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:24:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44511 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbaHFBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:24:49 -0400
Message-ID: <53E183A7.80905@huawei.com>
Date: Wed, 6 Aug 2014 09:23:51 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Stuart Yoder <b08248@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [RFC PATCH 03/11] PCI/MSI: Refactor pci_dev_msi_enabled()
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>	<1406344128-27055-4-git-send-email-wangyijing@huawei.com> <CALRxmdB0Ltt3_G=D4i7x47pHCtCKo8RHgn-hgN+u=px22dimOA@mail.gmail.com>
In-Reply-To: <CALRxmdB0Ltt3_G=D4i7x47pHCtCKo8RHgn-hgN+u=px22dimOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/6 6:35, Stuart Yoder wrote:
> On Fri, Jul 25, 2014 at 10:08 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Pci_dev_msi_enabled() is used to check whether device
>> MSI/MSIX enabled. Refactor this function  to suuport
>> checking only device MSI or MSIX enabled.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> 
> So this patch refactors things so that checks like this:
>    > -       if (!dev->msi_enabled)
> 
> are moved into a function:
>    > +       if (!pci_dev_msi_enabled(dev, MSI_TYPE))
> 
> Can you explain a bit more why this  needed.   Is it just cleanup?

Hi Stuart, it's not just cleanup, because "[RFC PATCH 08/11] PCI/MSI: Introduce new struct msi_irqs and struct msi_ops"
introduced struct msi_irqs, so the code will change to
if (!dev->msi_irqs->msi_enabled)

I think driver should not need to know the details of MSI members.
So I try to rework the pci_dev_msi_enabled() to hide the detailed MSI info.


Thanks!
Yijing.


> 
> .
> 


-- 
Thanks!
Yijing

