Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbaKNA0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:26:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:18964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbaKNA0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:26:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487367179"
Message-ID: <54654C10.2040102@linux.intel.com>
Date: Fri, 14 Nov 2014 08:25:52 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com>
In-Reply-To: <54651BE2.9080008@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 5:00, Marc Zyngier wrote:
> On 13/11/14 11:43, Jiang Liu wrote:
>> This patch set is based on tip/irq/irqdomain and tries to refine
>> interfaces to support irqdomain for generic MSI and PCI MSI.
>>
>> With this patch set applied, the generic MSI and PCI MSI interfaces
>> are much easier to use. For extreme case, you only need to define
>> a "struct msi_domain_info" and don't need to implement any callbacks,
>> just using the default callbacks is OK:)
>>
>> This patch set is also a preparation for:
>> 1) Kill all weak functions in drivers/pci/msi.c
>> 2) Implement support for non-PCI-compliant MSI device
> 
> I've rebased (once more!) the GICv3 ITS driver on top of this, and this
> is definitely a major improvement. This is basically the first version
> I can use without having to hack into the core code (apart from the
> couple of nits I've mentioned earlier).
Sorry for the rebasing, but I hope it worthy rebasing:)

> 
> Now, Thomas' idea of putting the irq_domain close to the bus is very
> appealing, and I've tweaked an earlier patch in order to do this:
I feel that's the right direction. There are other threads discussing
associating an MSI controller structure with each PCI bus (at least
root bus).
http://www.spinics.net/lists/arm-kernel/msg376328.html
Regards!
Gerry
