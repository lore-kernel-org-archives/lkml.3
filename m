Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3KNKb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:31:57 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:57815 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753197Ab3KNKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:31:55 -0500
MIME-Version: 1.0
In-Reply-To: <528387CF.5090105@arm.com>
References: <1384340725-26073-1-git-send-email-vkale@apm.com>
	<1384340725-26073-2-git-send-email-vkale@apm.com>
	<528387CF.5090105@arm.com>
Date: Thu, 14 Nov 2013 16:01:53 +0530
Message-ID: <CAPrCYke4fguxq5cxX5-NpSNH55d9BNCyDsFPouGrT7M+4t3SoQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
From: Vinayak Kale <vkale@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@apm.com" <patches@apm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>, "jcm@redhat.com" <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


On Wed, Nov 13, 2013 at 7:38 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi Vinayak,
>
> On 13/11/13 11:05, Vinayak Kale wrote:
>> This patch adds an accessor function for IRQ_PER_CPU flag.
>> The accessor function is useful to dertermine whether an IRQ is percpu or not.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> ---
>>  include/linux/irqdesc.h |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
>> index 56fb646..acd8a3f 100644
>> --- a/include/linux/irqdesc.h
>> +++ b/include/linux/irqdesc.h
>> @@ -152,6 +152,14 @@ static inline int irq_balancing_disabled(unsigned int irq)
>>       return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
>>  }
>>
>> +static inline int irq_is_percpu(unsigned int irq)
>> +{
>> +     struct irq_desc *desc;
>> +
>> +     desc = irq_to_desc(irq);
>> +     return (desc && (desc->status_use_accessors & IRQ_PER_CPU)) ? 1 : 0;
>
> I don't think it is worth checking for the validity of "desc" here. All
> the other accessors assume that you've not passed a stupid "irq" value.
hmm..Okay, will remove the 'desc' validity check from here.
