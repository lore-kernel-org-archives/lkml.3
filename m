Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaDCRHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:07:35 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45588 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaDCRHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:07:32 -0400
MIME-Version: 1.0
In-Reply-To: <533D7D8B.2030806@arm.com>
References: <1396538266-13245-1-git-send-email-eric.auger@linaro.org>
	<533D7D8B.2030806@arm.com>
Date: Thu, 3 Apr 2014 10:07:30 -0700
Message-ID: <CAMJs5B-YP8dsiapL=wpue5zhH1DruKENvAPtzNnvvRbCvqU-HQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: KVM: Handle IPA unmapping on memory region deletion
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>,
        "eric.auger@st.com" <eric.auger@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "christophe.barnichon@st.com" <christophe.barnichon@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2014 08:26, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Eric,
>
> On 03/04/14 16:17, Eric Auger wrote:
>> Currently when a KVM region is removed using
>> kvm_vm_ioctl_set_memory_region (with memory region size equal to 0), the
>> corresponding intermediate physical memory is not unmapped.
>>
>> This patch unmaps the region's IPA range in
>> kvm_arch_commit_memory_region using unmap_stage2_range.
>>
>> The patch was tested on QEMU VFIO based use case where RAM memory region
>> creation/deletion frequently happens for IRQ handling.
>>
>> Notes:
>> - the KVM_MR_MOVE case shall request some similar addition but I cannot test
>>   this currently
>
> I think you should try to handle it anyway. I'm sure you could hack QEMU
> to do this test it, but even if you don't, better plug that hole right now.
>
I don't think we want untested code in the kernel if we can avoid it,
so I would say, either test it somehow (kvm-unit-tests ?) or print a
warning...?

-Christoffer
