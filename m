Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaBCVWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:22:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:36365 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:22:06 -0500
Message-ID: <52F0086F.60103@linux.vnet.ibm.com>
Date: Mon, 03 Feb 2014 13:21:51 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/8] powerpc: add hvcalls for 24x7 and gpci (get performance
 counter info)
References: <20140201055806.A25152C00B2@ozlabs.org>
In-Reply-To: <20140201055806.A25152C00B2@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020321-9332-0000-0000-000002FA75D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 09:58 PM, Michael Ellerman wrote:
> On Thu, 2014-16-01 at 23:53:49 UTC, Cody P Schafer wrote:
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   arch/powerpc/include/asm/hvcall.h | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
>> index d8b600b..48d6efa 100644
>> --- a/arch/powerpc/include/asm/hvcall.h
>> +++ b/arch/powerpc/include/asm/hvcall.h
>> @@ -269,11 +269,15 @@
>>   #define H_COP			0x304
>>   #define H_GET_MPP_X		0x314
>>   #define H_SET_MODE		0x31C
>> -#define MAX_HCALL_OPCODE	H_SET_MODE
>> +#define H_GET_24X7_CATALOG_PAGE 0xF078
>> +#define H_GET_24X7_DATA		0xF07C
>> +#define H_GET_PERF_COUNTER_INFO 0xF080
>
> Ugh, why the hell did they put them up there.
>
>> +#define MAX_HCALL_OPCODE	H_GET_PERF_COUNTER_INFO
>
> We have an array which is sized based on this, which is unpleasant.
>
> I think you're better off putting these below in the platform specific section,
> and leaving MAX_HCALL_OPCODE alone. The only downside is you can't use the
> hcall tracing to see them.

Ya, I'm aware. I've got them up there as I did want to trace them :) . I 
don't see a big issue with moving them out of that section, though.

>>   /* Platform specific hcalls, used by KVM */
>>   #define H_RTAS			0xf000
>


