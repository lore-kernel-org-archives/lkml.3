Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaC3TKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 15:10:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34166 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbaC3TK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 15:10:29 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1396206040.9781.1.camel@vger.seibold.net>
References: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net> <1396161217.32686.1.camel@vger.seibold.net> <70a0dc4b-14d4-4684-9da8-b162a0303c17@email.android.com> <1396206040.9781.1.camel@vger.seibold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86: Fix the symbol versions on the 32-bit vDSO
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 30 Mar 2014 12:09:53 -0700
To: Stefani Seibold <stefani@seibold.net>
CC: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <6f109492-31f9-48f9-a4a2-31c2733e9877@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I applied the patch.  This is not ABI yet and Andy is right it makes more sense.

On March 30, 2014 12:00:40 PM PDT, Stefani Seibold <stefani@seibold.net> wrote:
>I think it is in review. I still wait for the confirmation of my assign
>form.
>
>Am Sonntag, den 30.03.2014, 09:59 -0700 schrieb H. Peter Anvin:
>> Has your glibc patch been accepted upstream yet? I'm assuming not, in
>which case this is a legitimate patch.
>> 
>> On March 29, 2014 11:33:37 PM PDT, Stefani Seibold
><stefani@seibold.net> wrote:
>> >Am Samstag, den 29.03.2014, 13:15 -0700 schrieb Andy Lutomirski:
>> >> The new symbols provide the same API as the 64-bit variants, so
>they
>> >> should have the same symbol version name.  This can't break
>> >> userspace, since these symbols are new for 32-bit Linux.
>> >> 
>> >
>> >This breaks my glibc patch... What is the benefit for doing this in
>> >that
>> >way?
>> >
>> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> ---
>> >>  arch/x86/vdso/vdso32/vdso32.lds.S | 10 +++++++---
>> >>  1 file changed, 7 insertions(+), 3 deletions(-)
>> >> 
>> >> diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S
>> >b/arch/x86/vdso/vdso32/vdso32.lds.S
>> >> index 28c4607..aadb8b9 100644
>> >> --- a/arch/x86/vdso/vdso32/vdso32.lds.S
>> >> +++ b/arch/x86/vdso/vdso32/vdso32.lds.S
>> >> @@ -23,14 +23,18 @@ ENTRY(__kernel_vsyscall);
>> >>   */
>> >>  VERSION
>> >>  {
>> >> +	LINUX_2.6 {
>> >> +	global:
>> >> +		__vdso_clock_gettime;
>> >> +		__vdso_gettimeofday;
>> >> +		__vdso_time;
>> >> +	};
>> >> +
>> >>  	LINUX_2.5 {
>> >>  	global:
>> >>  		__kernel_vsyscall;
>> >>  		__kernel_sigreturn;
>> >>  		__kernel_rt_sigreturn;
>> >> -		__vdso_clock_gettime;
>> >> -		__vdso_gettimeofday;
>> >> -		__vdso_time;
>> >>  	local: *;
>> >>  	};
>> >>  }
>> 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
