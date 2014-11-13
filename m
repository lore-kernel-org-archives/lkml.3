Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbaKMV2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:28:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41600 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934189AbaKMV2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:28:35 -0500
Message-ID: <5465227E.6000309@arm.com>
Date: Thu, 13 Nov 2014 21:28:30 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
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
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <alpine.DEB.2.11.1411132207470.3935@nanos>
In-Reply-To: <alpine.DEB.2.11.1411132207470.3935@nanos>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2014 21:28:31.0351 (UTC) FILETIME=[C5A3B870:01CFFF88]
X-MC-Unique: 114111321283300201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 21:11, Thomas Gleixner wrote:
> On Thu, 13 Nov 2014, Marc Zyngier wrote:
>> With the new stacked irq domains, it becomes pretty tempting
>> to allocate an MSI domain per PCI bus, which would remove
>> the requirement of either relying on arch-specific code, or
>> a default PCI MSI domain.
> 
> Right. That's what I roughly had in mind. And that would solve the
> multi-iommu issue on x86 nicely as well. We establish the association
> at the time where the bus gets populated. So the whole lookup magic
> simply goes away.

Great. I've pushed the whole thing out with this patch, the couple
of fixes I mentioned earlier, as well as the whole ITS code:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/stacked-its-v2

Time to go home.

	M.
-- 
Jazz is not dead. It just smells funny...

