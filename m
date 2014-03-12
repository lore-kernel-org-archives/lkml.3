Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaCLXBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:01:04 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:60243 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaCLXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <5320E689.7060607@zytor.com>
References: <1394664680-17799-1-git-send-email-stefani@seibold.net>
 <1394664680-17799-4-git-send-email-stefani@seibold.net> <5320E689.7060607@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 15:59:58 -0700
Message-ID: <CALCETrXQJvkk-5ncSgTyoy9sCN0AT+h9-1F6wAnxqRm242PjrQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 3:58 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/12/2014 03:51 PM, Stefani Seibold wrote:
>> This patch enables 32 bit vDSO which are larger than a page. Currently
>> two pages are reserved, this should be enough for future improvements.
>>
>> Signed-off-by: Stefani Seibold <stefani@seibold.net>
>> ---
>>  arch/x86/include/asm/fixmap.h |  4 +++-
>>  arch/x86/vdso/vdso32-setup.c  | 29 +++++++++++++++++++----------
>>  2 files changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
>> index 094d0cc..f513f14 100644
>> --- a/arch/x86/include/asm/fixmap.h
>> +++ b/arch/x86/include/asm/fixmap.h
>> @@ -43,6 +43,8 @@ extern unsigned long __FIXADDR_TOP;
>>
>>  #define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
>>  #define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
>> +
>> +#define MAX_VDSO_PAGES       2
>>  #else
>>  #define FIXADDR_TOP  (VSYSCALL_END-PAGE_SIZE)
>>
>> @@ -74,7 +76,7 @@ extern unsigned long __FIXADDR_TOP;
>>  enum fixed_addresses {
>>  #ifdef CONFIG_X86_32
>>       FIX_HOLE,
>> -     FIX_VDSO,
>> +     FIX_VDSO = MAX_VDSO_PAGES,
>>       VVAR_PAGE,
>>       VSYSCALL_HPET,
>
> Can we make this FIX_HOLE + MAX_VDSO_PAGES or at least a comment
> explaning the constraint here... otherwise I fear random breakage.

Note that this code is completely unnecessary if either of my patch
sets is accepted.  Since you're the maintainer, can you give an
opinion? :)

--Andy
