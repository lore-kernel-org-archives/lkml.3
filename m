Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab3BLSBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:01:42 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:46759 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589Ab3BLSBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:01:36 -0500
Message-ID: <511A837B.8020804@kernel.org>
Date: Tue, 12 Feb 2013 13:01:31 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Should SPARC use cpuidle? (was: linux-next: build failure after merge
 of the final tree (acpi tree related))
References: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au> <51197D8B.6010407@kernel.org> <20130212173505.GA2155@merkur.ravnborg.org>
In-Reply-To: <20130212173505.GA2155@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 12:35 PM, Sam Ravnborg wrote:
>>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> ---
>>>  arch/sparc/include/asm/processor.h | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/sparc/include/asm/processor.h b/arch/sparc/include/asm/processor.h
>>> index 34baa35..622cfa5 100644
>>> --- a/arch/sparc/include/asm/processor.h
>>> +++ b/arch/sparc/include/asm/processor.h
>>> @@ -7,6 +7,8 @@
>>>  #endif
>>>  
>>>  #define nop() 		__asm__ __volatile__ ("nop")
>>> +#ifndef __ASSEMBLY__
>>>  extern void (*sparc_idle)(void);
>>> +#endif
>>>  
>>>  #endif
>>>
>>
>> Thank you Stephen!
>>
>> The last time I compiled a sparc kernel was in 1993:-)
>>
>> I've added your fix and Dave's Ack to this patch,
>> and updated it in my next branch.
> 
> Hi Len.
> 
> Can you please move the definition of sparc_idle to processor_32.h
> It is sparc32 specific - and then we do not need the __ASSEMBLY__ guards
> as the sparc32 variant are not used from assembler.

sure, let me know if attached works.

> Do you btw. have any hints how I can convert to the cpu_idle thing you hinted?

If you have exactly 1 idle state, then cpuidle isn't that interesting,
except, perhaps the standard residency counters.  If you have multiple
states to choose from, cpuidle becomes more valuable.

There are lots of cpuidle users now, including x86's intel_idle,
processor_idle, and the entire ARM tree.

In my tree right now is a patch to convert APM to cpuidle --
though as nobody has tested it yet I can't guarantee it is correct.

patches/issues related to idle should to to linux-pm@vger.kernel.org (on cc)

thanks,
-Len


