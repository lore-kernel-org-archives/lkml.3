Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967585Ab3DRPuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:50:06 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:65364 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966984Ab3DRPuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:50:04 -0400
Message-ID: <1B60A75A964047D8BB507EDE4456AFBF@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: <gregkh@linuxfoundation.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, <hpa@zytor.com>,
        <JBeulich@suse.com>, <jasowang@redhat.com>, <apw@canonical.com>,
        <olaf@aepfle.de>
References: <1366299886-6399-1-git-send-email-kys@microsoft.com> <20130418141748.GA21146@redhat.com>
Subject: Please, apply patch both 3.10 and 3.9 Re: [PATCH 1/1] X86: Handle Xen emulation of Hyper-V more gracefully
Date: Thu, 18 Apr 2013 18:49:59 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!


>> - /*
>> - * Xen emulates Hyper-V to support enlightened Windows.
>> - * Check to see first if we are on a Xen Hypervisor.
>> - */
>> - if (xen_cpuid_base())
>> - return false;

 . . . 

>>  void hv_register_vmbus_handler(int irq, irq_handler_t handler)
>>  {
>> + /*
>> + * Setup the IDT for hypervisor callback.
>> + */
>> + alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
>> +


Michael S. Tsirkin> Any chance we can fast-path this patch into 3.9 so 
Michael S. Tsirkin> that we don't release a kernel with hyper-v on Xen completely disabled?


 Yes, this backport from linux-next ( future 3.10 ) to 3.9 ( on 2013-04-18 -- 3.9-rc(7+N) )  look like usefull . . .

Please, apply patch both 3.10 and 3.9

Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


----- Original Message ----- 
From: "Michael S. Tsirkin" 
To: "K. Y. Srinivasan"
Cc:
Sent: Thursday, April 18, 2013 5:17 PM
Subject: Re: [PATCH 1/1] X86: Handle Xen emulation of Hyper-V more gracefully


> On Thu, Apr 18, 2013 at 08:44:46AM -0700, K. Y. Srinivasan wrote:
>> Install the Hyper-V specific interrupt handler only when needed. This would
>> permit us to get rid of the Xen check. Note that when the vmbus drivers invokes
>> the call to register its handler, we are sure to be running on Hyper-V.
>> 
>> Signed-off-by: K. Y. Srinivasan 
> 
> Looks good to me, this will address the concern. FWIW
> 
> Acked-by: Michael S. Tsirkin 
> 
> Any chance we can fast-path this patch into 3.9 so that we don't release
> a kernel with hyper-v on Xen completely disabled?
> 
>> ---

 . . .
  
>> - /*
>> - * Xen emulates Hyper-V to support enlightened Windows.
>> - * Check to see first if we are on a Xen Hypervisor.
>> - */
>> - if (xen_cpuid_base())
>> - return false;
>> -
>>  cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
>>        &eax, &hyp_signature[0], &hyp_signature[1], &hyp_signature[2]);
>>  
>> @@ -82,12 +75,6 @@ static void __init ms_hyperv_init_platform(void)
>>  
>>  if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>>  clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
>> -#if IS_ENABLED(CONFIG_HYPERV)
>> - /*
>> - * Setup the IDT for hypervisor callback.
>> - */
>> - alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
>> -#endif
>>  }

 . . .

>>  void hv_register_vmbus_handler(int irq, irq_handler_t handler)
>>  {
>> + /*
>> + * Setup the IDT for hypervisor callback.
>> + */
>> + alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, hyperv_callback_vector);
>> +
>>  vmbus_irq = irq;

 . . .

>>

