Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaEPSgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:36:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41529 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaEPSgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:36:48 -0400
Message-ID: <53765ABB.50602@infradead.org>
Date: Fri, 16 May 2014 11:36:43 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>
CC: x86-ml <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Cleanup console loglevels
References: <20140516174921.GA18778@pd.tnic> <20140516175154.GA18834@pd.tnic>
In-Reply-To: <20140516175154.GA18834@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 10:51 AM, Borislav Petkov wrote:
> On Fri, May 16, 2014 at 07:49:21PM +0200, Borislav Petkov wrote:
>> Hi,
>>
>> so I was staring at
>>
>> 12544697f12e ("x86_64: be less annoying on boot, v2")
>>
>> and how naked numbers mean sh*t and how I have to grep sources to find
>> out what this 10 thing means. So how about the following cleanup? We can
>> do it this way, we can do accessors and stuff, whatever. But the naked
>> numbers are plain misleading.
>>
>> So how about it? I'm asking whether it makes sense first before I go
>> and replace all tests of console_loglevel with naked numbers around the
>> tree.
>>
>> Thanks.
>>
>> ---
>> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
>> index 068054f4bf20..0029d974e431 100644
>> --- a/arch/x86/kernel/head64.c
>> +++ b/arch/x86/kernel/head64.c
>> @@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
>>  	 */
>>  	load_ucode_bsp();
>>  
>> -	if (console_loglevel == 10)
>> +	if (console_loglevel >= CONSOLE_LOGLEVEL_QUIET)
> 
> That's CONSOLE_LOGLEVEL_DEBUG, of course.
> 
> See, misleading. :-P
> 

Absolutely.  I'll ack it with that change.

-- 
~Randy
