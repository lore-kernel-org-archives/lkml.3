Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525Ab3HOHy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:54:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63132 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab3HOHyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:54:54 -0400
Message-ID: <520C8947.4020906@ozlabs.ru>
Date: Thu, 15 Aug 2013 17:54:47 +1000
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
References: <1375332272-22176-1-git-send-email-aik@ozlabs.ru> <1375332272-22176-4-git-send-email-aik@ozlabs.ru> <ED8250FB-B0A8-4C32-A960-20ADB5742D2B@suse.de> <520C81BE.70002@ozlabs.ru> <552A034A-CD3F-4737-B08A-E892E6420B83@suse.de> <836F3C3A-0031-4A16-B0CE-E6C1BA4925E4@suse.de> <520C8661.2000406@ozlabs.ru> <162759CE-0031-4571-A4A3-3BFE16445066@suse.de>
In-Reply-To: <162759CE-0031-4571-A4A3-3BFE16445066@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 05:43 PM, Alexander Graf wrote:
> 
> On 15.08.2013, at 09:42, Alexey Kardashevskiy wrote:
> 
>> On 08/15/2013 05:25 PM, Alexander Graf wrote:
>>>
>>> On 15.08.2013, at 09:24, Alexander Graf wrote:
>>>
>>>>
>>>> On 15.08.2013, at 09:22, Alexey Kardashevskiy wrote:
>>>>
>>>>> On 08/15/2013 05:16 PM, Alexander Graf wrote:
>>>>>>
>>>>>> On 01.08.2013, at 06:44, Alexey Kardashevskiy wrote:
>>>>>>
>>>>>>> This is to reserve a capablity number for upcoming support
>>>>>>> of VFIO-IOMMU DMA operations in real mode.
>>>>>>>
>>>>>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>>>>>
>>>>>>> ---
>>>>>>> Changes:
>>>>>>> 2013/07/16:
>>>>>>> * changed the number
>>>>>>>
>>>>>>> 2013/07/11:
>>>>>>> * changed order in a file, added comment about a gap in ioctl number
>>>>>>>
>>>>>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>>>>> ---
>>>>>>> include/uapi/linux/kvm.h | 4 ++++
>>>>>>> 1 file changed, 4 insertions(+)
>>>>>>>
>>>>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>>>>> index 99c2533..53c3f1f 100644
>>>>>>> --- a/include/uapi/linux/kvm.h
>>>>>>> +++ b/include/uapi/linux/kvm.h
>>>>>>> @@ -668,6 +668,7 @@ struct kvm_ppc_smmu_info {
>>>>>>> #define KVM_CAP_IRQ_XICS 92
>>>>>>> #define KVM_CAP_ARM_EL1_32BIT 93
>>>>>>> #define KVM_CAP_SPAPR_MULTITCE 94
>>>>>>> +#define KVM_CAP_SPAPR_TCE_IOMMU 95
>>>>>>>
>>>>>>> #ifdef KVM_CAP_IRQ_ROUTING
>>>>>>>
>>>>>>> @@ -933,6 +934,9 @@ struct kvm_s390_ucas_mapping {
>>>>>>> #define KVM_ARM_SET_DEVICE_ADDR	  _IOW(KVMIO,  0xab, struct kvm_arm_device_addr)
>>>>>>> /* Available with KVM_CAP_PPC_RTAS */
>>>>>>> #define KVM_PPC_RTAS_DEFINE_TOKEN _IOW(KVMIO,  0xac, struct kvm_rtas_token_args)
>>>>>>> +/* 0xad and 0xaf are already taken */
>>>>>>
>>>>>> so 0xad and 0xaf are already taken? where?
>>>>>
>>>>> Mistype :( s/af/ae/
>>>>>
>>>>> They are taken in this file:
>>>>>
>>>>> 1016 /* VM is being stopped by host */
>>>>> 1017 #define KVM_KVMCLOCK_CTRL         _IO(KVMIO,   0xad)
>>>>> 1018 #define KVM_ARM_VCPU_INIT         _IOW(KVMIO,  0xae, struct kvm_vcpu_init)
>>>>
>>>> Could you please make sure that whoever reads the comment in a year still knows where to look? :)
>>>
>>> Something like
>>>
>>>  /* 0xad is taken by KVM_KVMCLOCK_CTRL */
>>>  /* 0xaf is taken by KVM_ARM_VCPU_INIT */
>>
>>
>> Missed this mail and reposted without this comment but updated commit
>> message saying where they are used. Repost again?
> 
> The commit message doesn't really help, since you don't see that one when you read the header file later. So yes, please.


Ok. Reposted as "[PATCH v8] KVM: PPC: reserve a capability and ioctl
numbers for realmode VFIO". Thank you. Sorry for my disturbing ignorance.


-- 
Alexey
