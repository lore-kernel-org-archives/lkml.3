Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3KGSjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:39:03 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61062 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3KGSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXpzmw7qvDPxkW+y=_h5W+a+uyJp1xkz55oBXu9sC+t3A@mail.gmail.com>
References: <20131107174746.GA22344@www.outflux.net>
	<CALCETrXpzmw7qvDPxkW+y=_h5W+a+uyJp1xkz55oBXu9sC+t3A@mail.gmail.com>
Date: Thu, 7 Nov 2013 10:39:00 -0800
X-Google-Sender-Auth: 8iglGmHqLNmFhoj97l2Ucy2az5Y
Message-ID: <CAGXu5jJFv8Nkb89zq5029+35d9AwA4k1PRmP1VdY-LCCrJ4U6g@mail.gmail.com>
Subject: Re: [PATCH v2] seccomp: not compatible with ARM OABI
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Eric Paris <eparis@redhat.com>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>, James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 10:16 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Nov 7, 2013 at 9:47 AM, Kees Cook <keescook@chromium.org> wrote:
>> Make sure that seccomp filter won't be built when ARM OABI is in use,
>> since there is work needed to distinguish calling conventions. Until
>> that is done (which is likely never since OABI is deprecated), make
>> sure seccomp filter is unavailable in the OABI world.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v2:
>>  - toggle availability via HAVE_ARCH_SECCOMP_FILTER; James Hogan.
>> ---
>>  arch/arm/Kconfig |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 0a1dc697333c..a0a8590f3609 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -23,7 +23,7 @@ config ARM
>>         select HARDIRQS_SW_RESEND
>>         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
>>         select HAVE_ARCH_KGDB
>> -       select HAVE_ARCH_SECCOMP_FILTER
>> +       select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
>>         select HAVE_ARCH_TRACEHOOK
>>         select HAVE_BPF_JIT
>>         select HAVE_CONTEXT_TRACKING
>> @@ -1735,6 +1735,11 @@ config OABI_COMPAT
>>           in memory differs between the legacy ABI and the new ARM EABI
>>           (only for non "thumb" binaries). This option adds a tiny
>>           overhead to all syscalls and produces a slightly larger kernel.
>> +
>> +         The seccomp filter system will not be available when this is
>> +         selected, since there is no way yet to sensibly distinguish
>> +         between calling conventions during filtering.
>> +
>>           If you know you'll be using only pure EABI user space then you
>>           can say N here. If this option is not selected and you attempt
>>           to execute a legacy ABI binary then the result will be
>> --
>> 1.7.9.5
>>
>>
>
> FWIW, OABI-only (i.e. !AEABI, as opposed to OABI_COMPAT) is, in
> principle, supportable -- userspace would just have to know that, if
> build for OABI, the calling convention is different.

Right -- I opted for enforcing seccomp-on-ARM-means-EABI.

> I doubt this is worth supporting, though, and, if no one complains
> about your patch for a couple releases, then that would mean we could
> get away with adding AUDIT_ARCH_ARM_OABI or something (maybe for
> seccomp only) if needed.

Agreed.

Thanks again for looking at all this!

-Kees

-- 
Kees Cook
Chrome OS Security
