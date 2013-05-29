Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967199Ab3E2X31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:29:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41825 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3E2X3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:29:21 -0400
Message-ID: <51A68F49.6020908@ozlabs.ru>
Date: Thu, 30 May 2013 09:29:13 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1369763138.18630.3@snotra> <51A53E20.3020205@ozlabs.ru> <1369784115.18630.27@snotra> <51A547F0.8090406@ozlabs.ru> <1369857949.18630.42@snotra> <51A68AE9.6070709@ozlabs.ru> <1369869272.18630.47@snotra>
In-Reply-To: <1369869272.18630.47@snotra>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 09:14 AM, Scott Wood wrote:
> On 05/29/2013 06:10:33 PM, Alexey Kardashevskiy wrote:
>> On 05/30/2013 06:05 AM, Scott Wood wrote:
>> > On 05/28/2013 07:12:32 PM, Alexey Kardashevskiy wrote:
>> >> On 05/29/2013 09:35 AM, Scott Wood wrote:
>> >> > On 05/28/2013 06:30:40 PM, Alexey Kardashevskiy wrote:
>> >> >> >> >>> @@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
>> >> >> >> >>> #define KVM_GET_DEVICE_ATTR      _IOW(KVMIO,  0xe2, struct
>> >> >> >> >>> kvm_device_attr)
>> >> >> >> >>> #define KVM_HAS_DEVICE_ATTR      _IOW(KVMIO,  0xe3, struct
>> >> >> >> >>> kvm_device_attr)
>> >> >> >> >>>
>> >> >> >> >>> +/* ioctl for SPAPR TCE IOMMU */
>> >> >> >> >>> +#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct
>> >> >> >> >>> kvm_create_spapr_tce_iommu)
>> >> >> >> >>
>> >> >> >> >> Shouldn't this go under the vm ioctl section?
>> >> >> >>
>> >> >> >>
>> >> >> >> The KVM_CREATE_SPAPR_TCE_IOMMU ioctl (the version for emulated
>> >> >> devices) is
>> >> >> >> in this section so I decided to keep them together. Wrong?
>> >> >> >
>> >> >> > You decided to keep KVM_CREATE_SPAPR_TCE_IOMMU together with
>> >> >> > KVM_CREATE_SPAPR_TCE_IOMMU?
>> >> >>
>> >> >> Yes.
>> >> >
>> >> > Sigh.  That's the same thing repeated.  There's only one IOCTL.
>> >> Nothing is
>> >> > being "kept together".
>> >>
>> >> Sorry, I meant this ioctl - KVM_CREATE_SPAPR_TCE.
>> >
>> > But you didn't put it in the same section as KVM_CREATE_SPAPR_TCE.  0xe0
>> > begins a different section.
>>
>> It is not really obvious that there are sections as no comment defines
>> those :)
> 
> There is a comment /* ioctls for fds returned by KVM_CREATE_DEVICE */
> 
> Putting KVM_CREATE_DEVICE in there was mainly to avoid dealing with the
> ioctl number conflict mess in the vm-ioctl section, but at least that one
> is related to the device control API. :-)
> 
>> But yes, makes sense to move it up a bit and change the code to 0xad.
> 
> 0xad is KVM_KVMCLOCK_CTRL

That's it. I am _completely_ confused now. No system whatsoever :(
What rule should I use in order to choose the number for my new ioctl? :)



-- 
Alexey
