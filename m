Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760437Ab3HOHWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:22:48 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53548 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850Ab3HOHWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:22:45 -0400
Message-ID: <520C81BE.70002@ozlabs.ru>
Date: Thu, 15 Aug 2013 17:22:38 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 03/10] KVM: PPC: reserve a capability and ioctl numbers
 for realmode VFIO
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru> <1375332272-22176-4-git-send-email-aik@ozlabs.ru> <ED8250FB-B0A8-4C32-A960-20ADB5742D2B@suse.de>
In-Reply-To: <ED8250FB-B0A8-4C32-A960-20ADB5742D2B@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 05:16 PM, Alexander Graf wrote:
> 
> On 01.08.2013, at 06:44, Alexey Kardashevskiy wrote:
> 
>> This is to reserve a capablity number for upcoming support
>> of VFIO-IOMMU DMA operations in real mode.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>
>> ---
>> Changes:
>> 2013/07/16:
>> * changed the number
>>
>> 2013/07/11:
>> * changed order in a file, added comment about a gap in ioctl number
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>> include/uapi/linux/kvm.h | 4 ++++
>> 1 file changed, 4 insertions(+)
>>
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 99c2533..53c3f1f 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -668,6 +668,7 @@ struct kvm_ppc_smmu_info {
>> #define KVM_CAP_IRQ_XICS 92
>> #define KVM_CAP_ARM_EL1_32BIT 93
>> #define KVM_CAP_SPAPR_MULTITCE 94
>> +#define KVM_CAP_SPAPR_TCE_IOMMU 95
>>
>> #ifdef KVM_CAP_IRQ_ROUTING
>>
>> @@ -933,6 +934,9 @@ struct kvm_s390_ucas_mapping {
>> #define KVM_ARM_SET_DEVICE_ADDR	  _IOW(KVMIO,  0xab, struct kvm_arm_device_addr)
>> /* Available with KVM_CAP_PPC_RTAS */
>> #define KVM_PPC_RTAS_DEFINE_TOKEN _IOW(KVMIO,  0xac, struct kvm_rtas_token_args)
>> +/* 0xad and 0xaf are already taken */
> 
> so 0xad and 0xaf are already taken? where?

Mistype :( s/af/ae/

They are taken in this file:

1016 /* VM is being stopped by host */
1017 #define KVM_KVMCLOCK_CTRL         _IO(KVMIO,   0xad)
1018 #define KVM_ARM_VCPU_INIT         _IOW(KVMIO,  0xae, struct kvm_vcpu_init)

> 
>> +/* Available with KVM_CAP_SPAPR_TCE_IOMMU */
>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xaf, struct kvm_create_spapr_tce_iommu)
> 
> and why is this one 0xaf then?

Sorry, mistype. My bad. Sorry again.


> 
> Alex
> 
>>
>> /* ioctl for vm fd */
>> #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
>> -- 
>> 1.8.3.2
>>
> 


-- 
Alexey
