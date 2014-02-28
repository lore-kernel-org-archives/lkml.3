Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaB1PIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:08:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43396 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaB1PIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:08:36 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1393572505.1019.10.camel@wall-e.seibold.net>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com> <cover.1393545985.git.luto@amacapital.net> <2f5d45b67dcd2c4ba58ed7ff13cfcd7a4da977fa.1393545985.git.luto@amacapital.net> <1393572505.1019.10.camel@wall-e.seibold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 1/4] x86: Use the default ABI for the 32-bit vDSO
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 28 Feb 2014 07:06:29 -0800
To: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>
CC: X86 ML <x86@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Message-ID: <e33a0c21-5d74-4584-ac35-8cd45a905310@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How many internal function calls are there? It seems we should try to avoid those as much as possible by suitable inlining.

On February 27, 2014 11:28:25 PM PST, Stefani Seibold <stefani@seibold.net> wrote:
>Am Donnerstag, den 27.02.2014, 16:18 -0800 schrieb Andy Lutomirski:
>> There's no reason for the vDSO to use a special function call ABI. 
>Use
>> the platform defaults.
>> 
>
>The only reason was performance. What is good for the kernel should be
>also good for the VDSO. Now all functions inside the VDSO will pass the
>arguments by stack.
>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/vdso/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
>> index 92daaa6..80584f5 100644
>> --- a/arch/x86/vdso/Makefile
>> +++ b/arch/x86/vdso/Makefile
>> @@ -149,7 +149,7 @@ KBUILD_CFLAGS_32 := $(filter-out
>-m64,$(KBUILD_CFLAGS))
>>  KBUILD_CFLAGS_32 := $(filter-out
>-mcmodel=kernel,$(KBUILD_CFLAGS_32))
>>  KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
>>  KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
>> -KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=3
>-freg-struct-return -fpic
>> +KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
>>  $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
>>  
>>  $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
