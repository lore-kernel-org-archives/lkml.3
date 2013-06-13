Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab3FMCpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:45:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53783 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3FMCpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:45:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51B93221.2040505@jp.fujitsu.com>
Date: Thu, 13 Jun 2013 11:44:49 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: bhelgaas@google.com
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        ishii.hironobu@jp.fujitsu.com, ddutile@redhat.com, bill.sumner@hp.com,
        alex.williamson@redhat.com, vgoyal@redhat.com, hbabu@us.ibm.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com> <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com> <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com> <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
In-Reply-To: <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/12 13:45), Bjorn Helgaas wrote:
> [+cc Vivek, Haren; sorry I didn't think to add you earlier]
> 
> On Tue, Jun 11, 2013 at 12:08 AM, Takao Indoh
> <indou.takao@jp.fujitsu.com> wrote:
>> (2013/06/11 11:20), Bjorn Helgaas wrote:
> 
>>> I'm not sure you need to reset legacy devices (or non-PCI devices)
>>> yet, but the current hook isn't anchored anywhere -- it's just an
>>> fs_initcall() that doesn't give the reader any clue about the
>>> connection between the reset and the problem it's solving.
>>>
>>> If we do something like this patch, I think it needs to be done at the
>>> point where we enable or disable the IOMMU.  That way, it's connected
>>> to the important event, and there's a clue about how to make
>>> corresponding fixes for other IOMMUs.
>>
>> Ok. pci_iommu_init() is appropriate place to add this hook?
> 
> I looked at various IOMMU init places today, and it's far more
> complicated and varied than I had hoped.
> 
> This reset scheme depends on enumerating PCI devices before we
> initialize the IOMMU used by those devices.  x86 works that way today,
> but not all architectures do (see the sparc pci_fire_pbm_init(), for

Sorry, could you tell me which part depends on architecture?

> example).  And I think conceptually, the IOMMU should be enumerated
> and initialized *before* the devices that use it.
> 
> So I'm uncomfortable with that aspect of this scheme.
> 
> It would be at least conceivable to reset the devices in the system
> kernel, before the kexec.  I know we want to do as little as possible
> in the crashing kernel, but it's at least a possibility, and it might
> be cleaner.

I bet this will be not accepted by kdump maintainer. Everything in panic
kernel is unreliable.

Thanks,
Takao Indoh

