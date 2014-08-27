Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490AbaH0PYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:24:53 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:62414 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935466AbaH0PYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:24:50 -0400
Message-ID: <53FDF82A.4090606@linaro.org>
Date: Wed, 27 Aug 2014 17:24:26 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, joel.schopp@amd.com, kim.phillips@freescale.com,
        linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: Re: [RFC 9/9] KVM: KVM_VFIO: ARM: implement irq forwarding control
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>	 <1408973264-30384-10-git-send-email-eric.auger@linaro.org> <1409079769.2906.131.camel@ul30vt.home>
In-Reply-To: <1409079769.2906.131.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 09:02 PM, Alex Williamson wrote:
> On Mon, 2014-08-25 at 15:27 +0200, Eric Auger wrote:
>> Implements ARM specific KVM-VFIO device group commands:
>> - KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ
>> - KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ
>> capability can be queried using KVM_HAS_DEVICE_ATTR.
>>
>> The new commands enable to set IRQ forwarding on/off for a given
>> IRQ index of a VFIO platform device.
>>
>> as soon as a forwarded irq is set, a reference to the VFIO device
>> is taken by the kvm-vfio device.
>>
>> The kvm-vfio device stores in the kvm_vfio_arch_data the list
>> of "assigned" devices (kvm_vfio_device). Each kvm_vfio_device
>> stores the list of assigned IRQs (potentially allowed a subset of
>> IRQ to be forwarded)
>>
>> The kvm-vfio device programs both the GIC and vGIC. Also it
>> clears the active bit on destruction, in case the guest did not
>> do it itself.
>>
>> Changing the forwarded state is not allowed in the critical
>> section starting from VFIO IRQ handler to LR programming. It is
>> up to the client to take care of this.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  arch/arm/include/asm/kvm_host.h |   2 +
>>  arch/arm/kvm/Makefile           |   2 +-
>>  arch/arm/kvm/kvm_vfio_arm.c     | 599 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 602 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm/kvm/kvm_vfio_arm.c
> 
> I'm really happy that it seems like the kvm-vfio device is going to work
> for you, but I think too much stuff is being pushed out to arch code
> here.  Exporting the interfaces in patches 7 & 8 are setting the stage
> for duplicate code for anyone wanting to implement device attributes.
> Instead, I think the core code should support the list of
> kvm_vfio_devices with proper cleanup, and we should attempt to access
> the kvm_vfio_ callbacks as little as possible from arch code.  Thanks,

OK. my next iteration will feature much more generic code.

Thanks for the review

Best Regards

Eric

> 
> Alex
> 

