Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3KGR0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:26:49 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54672 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3KGR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:26:46 -0500
MIME-Version: 1.0
In-Reply-To: <527B72AF.50002@imgtec.com>
References: <20131106233117.GA24545@www.outflux.net>
	<527B72AF.50002@imgtec.com>
Date: Thu, 7 Nov 2013 09:26:45 -0800
X-Google-Sender-Auth: UFaIbluCuUsRbhj6CCNiXgWtX4U
Message-ID: <CAGXu5jJn3jJs+mB76ZxOu_ibXuo9Q3mVeKjruZsJRRKpuUJd3A@mail.gmail.com>
Subject: Re: [PATCH] seccomp: not compatible with ARM OABI
From: Kees Cook <keescook@chromium.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Eric Paris <eparis@redhat.com>,
        libseccomp-discuss@lists.sourceforge.net,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 2:59 AM, James Hogan <james.hogan@imgtec.com> wrote:
> Hi,
>
> On 06/11/13 23:31, Kees Cook wrote:
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index af2cc6eabcc7..6eaca7d92399 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -331,12 +331,15 @@ config HAVE_ARCH_SECCOMP_FILTER
>>
>>  config SECCOMP_FILTER
>>       def_bool y
>> -     depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
>> +     depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET && !OABI_COMPAT
>
> Isn't this the whole point of HAVE_ARCH_SECCOMP_FILTER?
>
> Just change the select in arch/arm/Kconfig to this:
>
>         select HAVE_ARCH_SECCOMP_FILTER if !OABI_COMPAT

Oh! Yeah, that's a much cleaner way to handle it. I totally forgot
that "select" could be conditional. I will respin it that way.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
