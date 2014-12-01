Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaLAO5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:57:08 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62592 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaLAO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:57:05 -0500
Message-ID: <547C8166.9020401@linaro.org>
Date: Mon, 01 Dec 2014 15:55:34 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v3 2/8] KVM: arm64: Enable the KVM-VFIO device
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org> <1416767760-14487-3-git-send-email-eric.auger@linaro.org> <20141130121402.GC82106@macair>
In-Reply-To: <20141130121402.GC82106@macair>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 01:14 PM, Christoffer Dall wrote:
> On Sun, Nov 23, 2014 at 07:35:54PM +0100, Eric Auger wrote:
>> Used by KVM-enabled VFIO-based device passthrough support in QEMU.
>>
>> Signed-off-by: Joel Schopp <joel.schopp@amd.com>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> Extracted from [RFC PATCH] arm64: KVM: add irqfd support
>> http://www.spinics.net/lists/kvm-arm/msg10798.html
>> ---
>>  arch/arm64/kvm/Kconfig  | 1 +
>>  arch/arm64/kvm/Makefile | 2 +-
>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 09c25c2..2edf926 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -26,6 +26,7 @@ config KVM
>>  	select KVM_ARM_HOST
>>  	select KVM_ARM_VGIC
>>  	select KVM_ARM_TIMER
>> +	select KVM_VFIO
>>  	select HAVE_KVM_EVENTFD
>>  	---help---
>>  	  Support hosting virtualized guest machines.
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 2e6b827..81ed091 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
>>  
>> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
>>  
>> -- 
>> 1.9.1
>>
> 
> Should these patches not be squashed into one?
Yes I can do.
> 
> Also, what do they enable at this point?  Should they be queued by the
> end of the series instead?
Well to me this patch should be moved even outside of this series. The
KVM-VFIO device is loaded when the QEMU VFIO device is instantiated.
This is used to record the VFIO groups in use. In VFIO platform case, if
the KVM-VFIO device does not exist, this is not fatal but we get a
warning in QEMU.

The KVM-VFIO device however is mandatory to enable forwarded irq feature.

Best Regards

Eric
> 
> -Christoffer
> 

