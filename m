Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995AbaAUFFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:05:15 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:37550 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaAUFFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:05:07 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 00:05:07 EST
From: Vineet Gupta <vgupta@synopsys.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>, Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v3] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
Thread-Topic: [PATCH v3] arch: use ASM_NL instead of ';' for assembler new
 line character in the macro
Thread-Index: AQHPFDHt63WzlyRIrUmDCRPNQCI9Sw==
Date: Tue, 21 Jan 2014 04:55:15 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075178198@IN01WEMBXA.internal.synopsys.com>
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com>
 <526F09B8.9030202@asianux.com> <526F11C0.1030809@asianux.com>
 <526F149A.3000306@asianux.com> <52733FEC.4010807@synopsys.com>
 <528DD92E.9070408@synopsys.com> <52C6AF2B.8050104@suse.cz>
 <C2D7FE5348E1B147BCA15975FBA23075175CC4@IN01WEMBXA.internal.synopsys.com>
 <52CA76D3.2010102@suse.cz> <52CE4496.5030401@synopsys.com>
 <52D01639.9000205@gmail.com> <52D1F6F1.1070006@gmail.com>
 <52DA4D09.7030904@gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.120]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Saturday 18 January 2014 03:14 PM, Chen Gang wrote:
> Hello Maintainers:
>
> Please help check this patch when you have time.
>
> Thanks.

Do you know whose tree this is goona go thru. I can take it thru ARC (but maybe
for 3.15, however it would be better it went thru mm or some such).

-Vineet

>
> On 01/12/2014 09:59 AM, Chen Gang wrote:
>> For some assemblers, they use another character as newline in a macro
>> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
>> macro) instead of ';' for it.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> Acked-by: Vineet Gupta <vgupta@synopsys.com>
>> ---
>>  arch/arc/include/asm/linkage.h |  2 ++
>>  include/linux/linkage.h        | 19 ++++++++++++-------
>>  2 files changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arc/include/asm/linkage.h b/arch/arc/include/asm/linkage.h
>> index 0283e9e..66ee552 100644
>> --- a/arch/arc/include/asm/linkage.h
>> +++ b/arch/arc/include/asm/linkage.h
>> @@ -11,6 +11,8 @@
>>  
>>  #ifdef __ASSEMBLY__
>>  
>> +#define ASM_NL		 `	/* use '`' to mark new line in macro */
>> +
>>  /* Can't use the ENTRY macro in linux/linkage.h
>>   * gas considers ';' as comment vs. newline
>>   */
>> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
>> index d3e8ad2..a6a42dd 100644
>> --- a/include/linux/linkage.h
>> +++ b/include/linux/linkage.h
>> @@ -6,6 +6,11 @@
>>  #include <linux/export.h>
>>  #include <asm/linkage.h>
>>  
>> +/* Some toolchains use other characters (e.g. '`') to mark new line in macro */
>> +#ifndef ASM_NL
>> +#define ASM_NL		 ;
>> +#endif
>> +
>>  #ifdef __cplusplus
>>  #define CPP_ASMLINKAGE extern "C"
>>  #else
>> @@ -75,21 +80,21 @@
>>  
>>  #ifndef ENTRY
>>  #define ENTRY(name) \
>> -  .globl name; \
>> -  ALIGN; \
>> -  name:
>> +	.globl name ASM_NL \
>> +	ALIGN ASM_NL \
>> +	name:
>>  #endif
>>  #endif /* LINKER_SCRIPT */
>>  
>>  #ifndef WEAK
>>  #define WEAK(name)	   \
>> -	.weak name;	   \
>> +	.weak name ASM_NL   \
>>  	name:
>>  #endif
>>  
>>  #ifndef END
>>  #define END(name) \
>> -  .size name, .-name
>> +	.size name, .-name
>>  #endif
>>  
>>  /* If symbol 'name' is treated as a subroutine (gets called, and returns)
>> @@ -98,8 +103,8 @@
>>   */
>>  #ifndef ENDPROC
>>  #define ENDPROC(name) \
>> -  .type name, @function; \
>> -  END(name)
>> +	.type name, @function ASM_NL \
>> +	END(name)
>>  #endif
>>  
>>  #endif
>>
>

