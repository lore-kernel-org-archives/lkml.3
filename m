Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaAFFgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:36:25 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:45360 "EHLO
	smtp-relay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFFgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:36:23 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Michal Marek <mmarek@suse.cz>, Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
Thread-Topic: [PATCH v2] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
Thread-Index: AQHPCICsNXw9NzihgUenIdq+bXzVxA==
Date: Mon, 6 Jan 2014 05:36:19 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com>
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com>
 <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com>
 <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com>
 <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Friday 03 January 2014 06:08 PM, Michal Marek wrote:
> On 2013-11-21 10:58, Vineet Gupta wrote:
>> On 11/01/2013 11:15 AM, Vineet Gupta wrote:
>>> +CC Sam, Tim, Joe, Michal, David
>>>
>>> Guys can you please take a look at this patch and suggest the best way to merge.
>>>
>>> The root cause is some gas ports (including ARC) use ';' for comment (vs. newline)
>>> More background at https://lkml.org/lkml/2013/10/24/365
>> Ping ! Any objections to this. Given that this is exception case, it is simpler
>> than defining a Kconfig control.
>>
>> -Vineet
>>>
>>> On 10/29/2013 07:21 AM, Chen Gang wrote:
>>>> For some assemblers, they use another character as newline in a macro
>>>> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
>>>> macro) instead of ';' for it.
>>>>
>>>> Also need notice about code styles ('\t' for each line).
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  arch/arc/include/asm/linkage.h |    2 ++
>>>>  include/linux/linkage.h        |   19 ++++++++++++-------
>>>>  2 files changed, 14 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
>>>> index 0283e9e..66ee552 100644
>>>> --- a/arch/arc/include/asm/linkage.h
>>>> +++ b/arch/arc/include/asm/linkage.h
>>>> @@ -11,6 +11,8 @@
>>>>  
>>>>  #ifdef __ASSEMBLY__
>>>>  
>>>> +#define ASM_NL		 `	/* use '`' to mark new line in macro */
>>>> +
>>>>  /* Can't use the ENTRY macro in linux/linkage.h
>>>>   * gas considers ';' as comment vs. newline
>>>>   */
>>>> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
>>>> index d3e8ad2..a6a42dd 100644
>>>> --- a/include/linux/linkage.h
>>>> +++ b/include/linux/linkage.h
>>>> @@ -6,6 +6,11 @@
>>>>  #include <linux/export.h>
>>>>  #include <asm/linkage.h>
>>>>  
>>>> +/* Some toolchains use other characters (e.g. '`') to mark new line in macro */
>>>> +#ifndef ASM_NL
>>>> +#define ASM_NL		 ;
>>>> +#endif
>>>> +
>>>>  #ifdef __cplusplus
>>>>  #define CPP_ASMLINKAGE extern "C"
>>>>  #else
>>>> @@ -75,21 +80,21 @@
>>>>  
>>>>  #ifndef ENTRY
>>>>  #define ENTRY(name) \
>>>> -  .globl name; \
>>>> -  ALIGN; \
>>>> -  name:
>>>> +	.globl name ASM_NL \
>>>> +	ALIGN ASM_NL \
>>>> +	name:
>>>>  #endif
>>>>  #endif /* LINKER_SCRIPT */
>>>>  
>>>>  #ifndef WEAK
>>>>  #define WEAK(name)	   \
>>>> -	.weak name;	   \
>>>> +	.weak name ASM_NL   \
>>>>  	name:
>>>>  #endif
>>>>  
>>>>  #ifndef END
>>>>  #define END(name) \
>>>> -  .size name, .-name
>>>> +	.size name, .-name
>>>>  #endif
>>>>  
>>>>  /* If symbol 'name' is treated as a subroutine (gets called, and returns)
>>>> @@ -98,8 +103,8 @@
>>>>   */
>>>>  #ifndef ENDPROC
>>>>  #define ENDPROC(name) \
>>>> -  .type name, @function; \
>>>> -  END(name)
>>>> +	.type name, @function ASM_NL \
>>>> +	END(name)
>>>>  #endif
>>>>  
>>>>  #endif
>>>>
>>>

Did you hit reply by mistake - as I can't seem to find any comments...

-Vineet
