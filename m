Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbaCFAGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:06:04 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37932 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaCFAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:06:01 -0500
Message-ID: <5317BBE1.4050001@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2014 16:05:53 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        scottwood@freescale.com
Subject: Re: [PATCH v3 02/11] perf: add PMU_FORMAT_RANGE() helper for use
 by sw-like pmus
References: <20140304051936.33A712C01AB@ozlabs.org> <53158A2F.8050605@linux.vnet.ibm.com>
In-Reply-To: <53158A2F.8050605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-1344-0000-0000-0000000E0A94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 12:09 AM, Cody P Schafer wrote:
> On 03/03/2014 09:19 PM, Michael Ellerman wrote:
>> On Thu, 2014-27-02 at 21:04:55 UTC, Cody P Schafer wrote:
>>> Add PMU_FORMAT_RANGE() and PMU_FORMAT_RANGE_RESERVED() (for reserved
>>> areas) which generate functions to extract the relevent bits from
>>> event->attr.config{,1,2} for use by sw-like pmus where the
>>> 'config{,1,2}' values don't map directly to hardware registers.
>>>
>>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>>> ---
>>>   include/linux/perf_event.h | 17 +++++++++++++++++
>>>   1 file changed, 17 insertions(+)
>>>
>>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>>> index e56b07f..3da5081 100644
>>> --- a/include/linux/perf_event.h
>>> +++ b/include/linux/perf_event.h
>>> @@ -871,4 +871,21 @@ _name##_show(struct device
>>> *dev,                    \
>>>                                       \
>>>   static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
>>>
>>> +#define PMU_FORMAT_RANGE(name, attr_var, bit_start, bit_end)        \
>>> +PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);        \
>>> +PMU_FORMAT_RANGE_RESERVED(name, attr_var, bit_start, bit_end)
>>
>> I really think these should have event in the name.
>>
>> Someone looking at the code is going to see event_get_foo() and wonder
>> where
>> that is defined. Grep won't find a definition, tags won't find a
>> definition,
>> the least you can do is have the macro name give some hint.
>>
>
> That is a good point (grep-ability). Let me think about this. There is
> also the possibility that I could adjust the event_get_*() naming to
> something else. format_get_*()? event_get_format_*()? (these names keep
> growing...)
>

I've gone with a format_get(name, event) style macro (making it more 
grep-able), in v4.
Feel free to direct further discussion to the v4 posting.

