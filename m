Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947007Ab3BHUSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:18:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36312 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780Ab3BHUSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:18:51 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
References: <20130208191213.GA25081@www.outflux.net> <00780235-deac-4f80-b936-867834e05661@email.android.com> <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com> <5115553A.5000708@zytor.com> <CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 08 Feb 2013 12:18:27 -0800
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Message-ID: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analogy fail.  The /dev/mem lockout applies to system RAM, not MMIO.

I fear COMPROMISE_KERNEL is becoming the new SYS_ADMIN, which in turn is the new root.  Why?  Because it is inhebtly about a usage model, not about a specific resource.

Kees Cook <keescook@chromium.org> wrote:

>On Fri, Feb 8, 2013 at 11:42 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 02/08/2013 11:18 AM, Kees Cook wrote:
>>>
>>> No. CAP_RAWIO is for reading. Writing needs a much stronger check.
>>
>> If so, I suspect we need to do this for *all* raw I/O... but I keep
>> wondering how much more sensitive writing really is than reading.
>
>Well, I think there's a reasonable distinction between systems that
>expect to strictly enforce user-space/kernel-space separation
>(CAP_COMPROMISE_KERNEL) and things that are fiddling with hardware
>(CAP_SYS_RAWIO).
>
>For example, even things like /dev/mem already have this separation
>(although it is stronger). You can't open /dev/mem without
>CAP_SYS_RAWIO, but if you do, you still can't write to RAM in
>/dev/mem. This might be one of the earliest examples of this
>distinction, actually.
>
>I think it's likely that after a while, we can convert some of these
>proposed CAP_COMPROMISE_KERNEL checks in always-deny once we figure
>out how to deal with those areas more safely.
>
>-Kees
>
>--
>Kees Cook
>Chrome OS Security

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
