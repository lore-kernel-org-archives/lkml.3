Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbbALNlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:41:47 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49493 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbbALNlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:41:46 -0500
Message-ID: <54B3CEB3.1010709@linaro.org>
Date: Mon, 12 Jan 2015 14:40:03 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, gleb@kernel.org, pbonzini@redhat.com,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: Re: [PATCH v5 4/5] KVM: irqfd: use kvm_arch_is_virtual_intc_initialized
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org> <1417622832-5460-5-git-send-email-eric.auger@linaro.org> <20150111211713.GF3868@cbox>
In-Reply-To: <20150111211713.GF3868@cbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 10:17 PM, Christoffer Dall wrote:
> On Wed, Dec 03, 2014 at 05:07:11PM +0100, Eric Auger wrote:
>> On arm/arm64, the interrupt controller is dynamically instantiated.
>> There is a risk the user-space assigns an irqfd before this latter
>> is initialized and ready to accept virtual irq injection. On such
>> attempt, the IRQFD setup is rejected and -EAGAIN is returned.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  virt/kvm/eventfd.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index b0fb390..f837c83 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -314,6 +314,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>>  	unsigned int events;
>>  	int idx;
>>  
>> +	if (!kvm_arch_is_virtual_intc_initialized(kvm))
>> +		return -EAGAIN;
>> +
> 
> You can fold this into the patch that defines the static inline since
> nothing defines the KVM_HAVE_ARCH_... yet.
Not sure to understand what you mean:
__KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED was defined in previous patch
file (3/5). Nethertheless I can drop that patch file.

Thanks

Eric
> 
>>  	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
>>  	if (!irqfd)
>>  		return -ENOMEM;
>> -- 
>> 1.9.1
>>

