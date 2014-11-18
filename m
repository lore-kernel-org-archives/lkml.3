Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaKRRxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:53:47 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60559 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbaKRRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:53:46 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huxinwei\@huawei.com" <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: [PATCH 00/10] Save MSI chip in pci_sys_data
In-Reply-To: <alpine.DEB.2.11.1411172138191.3909@nanos> (Thomas Gleixner's
	message of "Mon, 17 Nov 2014 21:02:46 +0000")
Organization: ARM Ltd
References: <1414396127-30023-1-git-send-email-wangyijing@huawei.com>
	<20141112042359.GK28161@google.com> <20141117025914.GC4280@google.com>
	<alpine.DEB.2.11.1411171035270.3909@nanos>
	<CAErSpo46d0OJbO6tuDUXb2q7+00BUuHzJdsCr+aOhY4we+zn=w@mail.gmail.com>
	<alpine.DEB.2.11.1411172138191.3909@nanos>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Tue, 18 Nov 2014 17:53:36 +0000
Message-ID: <87tx1wcs4f.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2014 at  9:02:46 pm GMT, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 17 Nov 2014, Bjorn Helgaas wrote:
>> On Mon, Nov 17, 2014 at 2:38 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > The simplest way to dead with it is that I pull in pci/msi (assuming
>> > that it contains only the above) and base the rest of it on top, so I
>> > can deal with the resulting conflicts. So you still can keep that in
>> > your pile and no matter who sends the pull request first everything
>> > will just fall in place.
>>
>> In addition to the ("Save MSI chip in pci_sys_data") series, my
>> pci/msi branch contains these:
>>
>>   f83386942702 s390/MSI: Use __msi_mask_irq() instead of default_msi_mask_irq()
>>   03f56e42d03e Revert "PCI: Add x86_msi.msi_mask_irq() and msix_mask_irq()"
>>   38737d82f9f0 PCI/MSI: Add pci_msi_ignore_mask to prevent writes to
>> MSI/MSI-X Mask Bits
>>
>> but I don't think it will hurt if you pull in those as well.
>
> They are blessed by you, so I don't worry :)
>
>> The bigger problem might be the first patch of the "Save MSI chip in
>> pci_sys_data", which renames "struct msi_chip" to "struct
>> msi_controller".  I asked Yijing to do that because I didn't think
>> "_chip" really conveyed any information.  I didn't know we were going
>> to have quite this many MSI-related patches to fix up.
>
> Not a big deal at all. I pulled your branch and fixed up the pending
> mess on top of it. Not a really big deal.
>
>> So I'll just leave my pci/msi branch as-is for now.  If the rename is
>> too painful, let me know and I'll drop the branch and we can rework
>> the rest of the "Save MSI chip in pci_sys_data" series to match.
>
> No, not a problem at all. If I can carry your branch and it is
> immutable then I think we are fine.
>
> The changes we have stashed on top of this which touch linux/msi.h and
> pci/msi.c are at the end of this mail. But most of this is
> selfcontained and wont hurt anything which does not enable the
> required config options. The diffstat is:
>
>  drivers/pci/msi.c   |  334 +++++++++++++++++++++++++++++++++++++++++-----------
>  include/linux/msi.h |  158 +++++++++++++++++++++++-
>  2 files changed, 422 insertions(+), 70 deletions(-)
>
> Looks large, but it provides common infrastructure which allows ARM64
> to implement MSI support w/o any of the gazillion weak arch
> callbacks. Jiangs x86 work distangles the convoluted mess we have with
> irq remapping etc. and we can have non PCI based MSI interrupts as a
> bonus.
>
> So I'm pretty happy with the outcome now. The stacked irqdomains
> really worked out well so far. I don't think that the pci/msi.c side
> will see much updates on that in the next weeks. Though based on that
> we'll try to get rid of the whole weak arch_xxx in the long run, but
> that's a different issue and nothing we need to worry about now.
>
> I'm going to push out the current state of affairs soon and will ask
> all involved folks to have a look on that. If I don't hear someone
> crying murder I'm going to make the branch immutable and push it into
> next so that ARM and x86 can follow up with their stuff which depends
> on that whole endavour.

I rebased my ITS series on top of this, and gave it a good
shake. Nothing fell out, so I'm inclined to say it is perfect.

I'll post the updated series for everyone's enjoyment...

Thanks for having put all that together!

	M.
-- 
Jazz is not dead. It just smells funny.
