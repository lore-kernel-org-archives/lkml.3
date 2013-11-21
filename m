Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3KUGKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:10:37 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:36707 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750927Ab3KUGKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:10:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAPrCYkefGMfweREk8bBKsO2VY4Tnc-fUZW8sw_K5ugRj5zJUFA@mail.gmail.com>
References: <1384946021-22100-1-git-send-email-vkale@apm.com>
	<1384946021-22100-2-git-send-email-vkale@apm.com>
	<528CFC77.5050200@codeaurora.org>
	<CAPrCYkefGMfweREk8bBKsO2VY4Tnc-fUZW8sw_K5ugRj5zJUFA@mail.gmail.com>
Date: Thu, 21 Nov 2013 11:40:14 +0530
Message-ID: <CAPrCYkdpHPPY6D1dj5R=QJ5mtmKUfTx+M7wRMV-t2LrZMdSW9w@mail.gmail.com>
Subject: Re: [PATCH V4 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
From: Vinayak Kale <vkale@apm.com>
To: Stephen Boyd <sboyd@codeaurora.org>, chris.smith@st.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        tglx <tglx@linutronix.de>, Will Deacon <will.deacon@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removing chris.smith@st.com]

On Thu, Nov 21, 2013 at 11:36 AM, Vinayak Kale <vkale@apm.com> wrote:
> On Wed, Nov 20, 2013 at 11:46 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 11/20/13 03:13, Vinayak Kale wrote:
>>> This patch adds an accessor function for IRQ_PER_CPU flag.
>>> The accessor function is useful to dertermine whether an IRQ is percpu or not.
>>>
>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>> ---
>>
>> This looks like a copy of Chris Smith's patch. Shouldn't Chris be the
>> author and the commit text be whatever Chris sent?
>
> In the cover letter of this patch series I did mention about Chris's
> earlier patch. I didn't know his email-id earlier, have found the
> mail-id now. CCing the mail-id to check whether it's still valid.
>

Chris's mail-id doesn't seem to be valid, the earlier mail to his
mail-id [chris.smith@st.com] bounced.
Please let me know in such case how to mention original author's credits.

>>
>>>  include/linux/irqdesc.h |    8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
>>> index 56fb646..26e2661 100644
>>> --- a/include/linux/irqdesc.h
>>> +++ b/include/linux/irqdesc.h
>>> @@ -152,6 +152,14 @@ static inline int irq_balancing_disabled(unsigned int irq)
>>>       return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
>>>  }
>>>
>>> +static inline int irq_is_percpu(unsigned int irq)
>>> +{
>>> +     struct irq_desc *desc;
>>> +
>>> +     desc = irq_to_desc(irq);
>>> +     return desc->status_use_accessors & IRQ_PER_CPU;
>>> +}
>>> +
>>>  static inline void
>>>  irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
>>>  {
>>
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> hosted by The Linux Foundation
>>
