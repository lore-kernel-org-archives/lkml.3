Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaHANR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:17:26 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58592 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaHANRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:17:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Yijing Wang <wangyijing@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
Date: Fri, 1 Aug 2014 15:16:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Paul.Mundt@huawei.com, Marc Zyngier <marc.zyngier@arm.com>,
        linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        virtualization@lists.linux-foundation.org,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <53D89502.60506@linux.intel.com> <53D89CA1.7000501@huawei.com>
In-Reply-To: <53D89CA1.7000501@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201408011516.26253.arnd@arndb.de>
X-Provags-ID: V02:K0:7H9iywbwAK6pklTnzxZ0UQUY9kyqxb7fyiTMt9bMgQX
 pZJLIIFdRx+XfKXpPwm0NjUAyf30ozvx6al3AyelFrtBptRhEf
 BJ44W1tzBZUEpVUgKcdZ+J/8ksy+Q+aXpfolMhOrjLi7a+68Lx
 jXV2NAH+ydzlebIt5tGclhYWVcFHOQaqAAQGloRTjTaGj9P+dE
 rEPD6tvTXKVm+rkUnLHwtY5giU1kgwaZzha2nb4AtFlvj+G1r4
 RRU/E3uypS97vN4fgF/OJfadKGb16N2kqF3SXmtp4BGBCUSOfg
 tC1z7zfKCkW4I0PVTjTkrI7WRTsqwF8BgnmPU0d7u4ff0EbQI5
 SGHXxt8z+0cATdkbXVVP0EY7TIKtrD/3+wEw9tknZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2014, Yijing Wang wrote:
> >>>
> >>> The other part I'm not completely sure about is how you want to
> >>> have MSIs map into normal IRQ descriptors. At the moment, all
> >>> MSI users are based on IRQ numbers, but this has known scalability problems.
> >>
> >> Hmmm, I still use the IRQ number to map the MSIs to IRQ description.
> >> I'm sorry, I don't understand you meaning.
> >> What are the scalability problems you mentioned ?
> > We have soft limitation of nr_irqs or hard limitation NR_IRQS,
> > we couldn't allocate as much irq number as we need in some cases,
> > such as to support MSI-x.
> 
> Oh, yes, this is a potential issue. Gerry, thanks for you explanation. :)

This should no longer be an issue, as arm64 uses CONFIG_SPARSE_IRQ
and the number of interrupts is not limited in any form.

My point was more that the device driver should not need to care about
the interrupt number: it gets made up on the spot when the MSI is
needed, and then it is only used to request the IRQ. This can be
simplified into one interface at the device driver level, even though
the internal still use numbers somewhere. If we ever remove IRQ numbers
from the driver API, this part doesn't need to get touched again.

	Arnd
