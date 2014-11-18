Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaKRFIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 00:08:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:58898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaKRFIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 00:08:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="488276109"
Message-ID: <546AD456.3030000@linux.intel.com>
Date: Tue, 18 Nov 2014 13:08:38 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Patch V3 0/9] Refine generic/PCI MSI irqodmian interfaces
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411180133130.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411180133130.3909@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 8:59, Thomas Gleixner wrote:
> On Mon, 17 Nov 2014, Jiang Liu wrote:
>> This patch set is based on tip/irq/irqdomain and tries to refine
>> interfaces to support irqdomain for generic MSI and PCI MSI.
> 
> So to make progress on that matter I picked that up along with a few
> other patches which affect the core code (more stacked irq callbacks
> and Marcs workaround for the handler assignment issue).
> 
> I rebased the whole lot on Bjorns pci/msi branch as discussed in this
> thread: https://lkml.org/lkml/2014/11/16/292
> 
> After that I spent quite some time to reorder and fold back patches so
> we have no obvious wreckage, but at the same time preserve at least
> some of the development process for this.
> 
> Finally I added docbook comments where missing (please provide them
> next time yourself).
Sure, need improvements on docs.

> 
> Marc ran an initial smoketest on an early iteration which did not fall
> into bits and pieces right away.
> 
> The only major change is that I got rid of the ugly
> 
> #ifndef msi_alloc_info_t
> 
> trickery by moving the generic version into include/asm-generic/msi.h
> 
> So if you want to use the generic version, you need to create your
> arch/xxx/include/asm/msi.h file which includes asm-generic/msi.h.
> 
> For the ones who want to override it, create
> arch/xxx/include/asm/msi.h, include whatever it takes and provide the
> proper typedef.
Two issues are solved by adding new header files, a good technique to
improve code quality:)

> 
> I'll send that patch (7bde31a7969f) out tomorrow morning as I want to
> have Arnds blessing for that.
> 
<snip>
> I really rely on your cooperation here, as I don't want to end up with
> an unexplainable mess when the stuff hits Linus tree and he starts
> rumaging for his diving harpune ....
I have rebased x86 changes onto tip/irq/irqdomain, it works perfectly:)

Regards!
Gerry
