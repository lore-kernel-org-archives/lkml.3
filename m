Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3HLLhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:37:16 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41583 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab3HLLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:37:12 -0400
Message-ID: <5208C8DD.3050204@linux.vnet.ibm.com>
Date: Mon, 12 Aug 2013 17:07:01 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: tony.luck@intel.com, bp@alien8.de, bhelgaas@google.com, rjw@sisk.pl,
        lance.ortiz@hp.com, m.chehab@samsung.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mce: acpi/apei: trace: Include PCIe AER trace event
 conditionally
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-2-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808152329.1f98b5e0@gandalf.local.home>
In-Reply-To: <20130808152329.1f98b5e0@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081222-3568-0000-0000-0000041277C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 12:53 AM, Steven Rostedt wrote:
> [ attempting to try out claws-mail, hopefully this messages isn't
> scrambled ;-) ]

Works just fine :)

>
> On Thu,  8 Aug 2013 23:57:49 +0530
> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> wrote:
>
>> Since we'll be adding multiple trace events to ras.h, we need to protect
>> each block appropriately so that they only get included in the right
>> places. Update PCIe AER trace event for this purpose.
>
> Why not make a separate file for each? You will have to define

The idea was to have all RAS-related trace points in a single place. 
This was discussed back when the PCIe AER trace event was added and so I 
chose to add the new event here as well.

> TRACE_EVENT_PCIE_AER for the users as well. That is, the places that
> include ras.h and use the trace_aer_*() tracepoints.

Do you mean the change I've done to aerdrv-errprint.c below? This trace 
point is currently only used there, so I guess we are ok?

Thanks,
Naveen


>
>
>>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> ---
>>   drivers/pci/pcie/aer/aerdrv_errprint.c | 1 +
>>   include/trace/events/ras.h             | 2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
>> index 2c7c9f5..4d06859 100644
>> --- a/drivers/pci/pcie/aer/aerdrv_errprint.c
>> +++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
>> @@ -24,6 +24,7 @@
>>   #include "aerdrv.h"
>>
>>   #define CREATE_TRACE_POINTS
>> +#define TRACE_EVENT_PCIE_AER
>>   #include <trace/events/ras.h>
>>
>>   #define AER_AGENT_RECEIVER		0
>> diff --git a/include/trace/events/ras.h b/include/trace/events/ras.h
>> index 88b8783..4a66142 100644
>> --- a/include/trace/events/ras.h
>> +++ b/include/trace/events/ras.h
>> @@ -1,7 +1,7 @@
>>   #undef TRACE_SYSTEM
>>   #define TRACE_SYSTEM ras
>>
>> -#if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#if (!defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)) && defined()
>
> I think it would look cleaner to encapsulate the one define with the
> other:
>
> #ifdef TRACE_EVENT_PCIE_AER
> #if !defined(_TRACE_AER_H) || defined(TRACE_HEADER_MULTI_READ)
>
>
> -- Steve
>
>>   #define _TRACE_AER_H
>>
>>   #include <linux/tracepoint.h>
>

