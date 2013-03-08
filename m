Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3CHHuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:50:03 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40576 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3CHHuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:50:01 -0500
MIME-Version: 1.0
In-Reply-To: <51399442.1080609@redhat.com>
References: <51397D1D.5030602@redhat.com>
	<1750036321.11235774.1362722613994.JavaMail.root@redhat.com>
	<CAE9FiQUtDcwJkPMPfjur8LQ+u0Hc2J7sbxC=xkcemqRQ1_Gd8g@mail.gmail.com>
	<CAE9FiQU7ccdWCL=t=Zn1w33GHpHk56=JXTcotn-Huq9Wiqu7wg@mail.gmail.com>
	<51399154.5030500@redhat.com>
	<CAE9FiQVPaG5P7mG9HoFzCkaxF62hkU5hEtq_FhdT7n+38aNs9A@mail.gmail.com>
	<51399442.1080609@redhat.com>
Date: Thu, 7 Mar 2013 23:50:00 -0800
X-Google-Sender-Auth: PkdE7vSUtFcqPRPPAg6uuZ0Tf2I
Message-ID: <CAE9FiQWCfnOjOuWKihv1GamgHb4KLrrPEiBTspQMqK7_fBDunw@mail.gmail.com>
Subject: Re: 3.9-rc1: crash kernel panic - not syncing: Can not allocate
 SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer
From: Yinghai Lu <yinghai@kernel.org>
To: WANG Chao <chaowang@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>, Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:33 PM, WANG Chao <chaowang@redhat.com> wrote:
> On 03/08/2013 03:27 PM, Yinghai Lu wrote:
>> On Thu, Mar 7, 2013 at 11:20 PM, WANG Chao <chaowang@redhat.com> wrote:
>>>>
>>>> looks like your system DO have DMAR table, please enable dmar
>>>> remapping in your kernel config.
>>>
>>> I've already got following config:
>>> CONFIG_DMAR_TABLE=y
>>> CONFIG_INTEL_IOMMU=y
>>> CONFIG_IRQ_REMAP=y
>>>
>>> but I don't have intel_iommu=on in kernel cmdline. IIRC, iommu will prevent
>>> 2nd kernel from booting ...
>>
>> Did you put intel_iommu=on on first and second cpu both?
>
> I tried, 2nd kernel didn't boot and keep splitting errors like these:
> [    2.106939] DMAR: No ATSR found
> [    2.110121] IOMMU 0 0xfed90000: using Queued invalidation
> [    2.115522] IOMMU 1 0xfed91000: using Queued invalidation
> [    2.120919] IOMMU: Setting RMRR:
> [    2.124162] IOMMU: Setting identity map for device 0000:00:02.0 [0xab800000
> - 0xaf9fffff]
> [    2.133099] IOMMU: Setting identity map for device 0000:00:1d.0 [0xaac95000
> - 0xaacb2fff]
> [    2.141305] IOMMU: Setting identity map for device 0000:00:1a.0 [0xaac95000
> - 0xaacb2fff]
> [    2.149503] IOMMU: Setting identity map for device 0000:00:14.0 [0xaac95000
> - 0xaacb2fff]
> [    2.157690] IOMMU: Prepare 0-16MiB unity mapping for LPC
> [    2.163011] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff
> [Errors, here we go]
> [    2.170932] dmar: DRHD: handling fault status reg 3
> [    2.170933] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> [    2.182486] dmar: DMAR:[DMA Write] Request device [00:02.0] fault addr ffffe000
> [    2.182486] DMAR:[fault reason 05] PTE Write access is not set
> [    2.195705] dmar: DRHD: handling fault status reg 3
> [    2.200570] dmar: DMAR:[DMA Read] Request device [00:02.0] fault addr ff873000
> [    2.200570] DMAR:[fault reason 06] PTE Read access is not set
> [    2.213618] dmar: DRHD: handling fault status reg 3

my Nehalem-EX and Westmere-EX is working with iommu enabled in second kernel.

what is 00:02.0 in your system?

Is your kernel upsteam kernel or redhat flavor one?

Thanks

Yinghai
