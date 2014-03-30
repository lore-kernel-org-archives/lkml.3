Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaC3Gt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 02:49:56 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:41654 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaC3Gtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 02:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <1396161217.32686.1.camel@vger.seibold.net>
References: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net>
 <1396161217.32686.1.camel@vger.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 29 Mar 2014 23:49:34 -0700
Message-ID: <CALCETrVgcTy+MF_tSbPTPKyUYO45A6hrz=JLLarRouXGKrZuyw@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix the symbol versions on the 32-bit vDSO
To: Stefani Seibold <stefani@seibold.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 11:33 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Samstag, den 29.03.2014, 13:15 -0700 schrieb Andy Lutomirski:
>> The new symbols provide the same API as the 64-bit variants, so they
>> should have the same symbol version name.  This can't break
>> userspace, since these symbols are new for 32-bit Linux.
>>
>
> This breaks my glibc patch... What is the benefit for doing this in that
> way?

The functions do the same thing as they do in the 64-bit and x32
cases, so the versions should be the same.

>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/vdso/vdso32/vdso32.lds.S | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
>> index 28c4607..aadb8b9 100644
>> --- a/arch/x86/vdso/vdso32/vdso32.lds.S
>> +++ b/arch/x86/vdso/vdso32/vdso32.lds.S
>> @@ -23,14 +23,18 @@ ENTRY(__kernel_vsyscall);
>>   */
>>  VERSION
>>  {
>> +     LINUX_2.6 {
>> +     global:
>> +             __vdso_clock_gettime;
>> +             __vdso_gettimeofday;
>> +             __vdso_time;
>> +     };
>> +
>>       LINUX_2.5 {
>>       global:
>>               __kernel_vsyscall;
>>               __kernel_sigreturn;
>>               __kernel_rt_sigreturn;
>> -             __vdso_clock_gettime;
>> -             __vdso_gettimeofday;
>> -             __vdso_time;
>>       local: *;
>>       };
>>  }
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
