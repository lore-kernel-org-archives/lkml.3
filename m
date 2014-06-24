Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbaFXTlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:41:14 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41169 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaFXTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <53A9C6EB.50900@zytor.com>
References: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net>
 <tip-5f56e7167e6d438324fcba87018255d81e201383@git.kernel.org>
 <20140622084754.GA15094@gmail.com> <CALCETrW_U7z7RC-D5+Ji+PQd73nR-=xQGH5uieb7y3Z7yzYPRw@mail.gmail.com>
 <CALCETrXohybf=Lk70j=hVG1zaAQ-mw8CVo6P59xjM2qsc-p+Gg@mail.gmail.com>
 <53A9C2C3.7050508@zytor.com> <CALCETrX8xJQwm=Cp63xSWsmsF1EXB9pPkZ46rX1u49f0oCfxfw@mail.gmail.com>
 <53A9C6EB.50900@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 24 Jun 2014 12:40:51 -0700
Message-ID: <CALCETrUEUeW4UywKUFzZwdPiyff+QcMpEiHi2-g=4_ODBm0qaQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/vdso: Discard the __bug_table section
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 11:43 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/24/2014 11:37 AM, Andy Lutomirski wrote:
>>>
>>> diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
>>> index f42e2ddc663d..94158e100f26 100644
>>> --- a/arch/x86/vdso/vdso2c.h
>>> +++ b/arch/x86/vdso/vdso2c.h
>>> @@ -99,8 +99,9 @@ static void BITSFUNC(copy_section)(struct
>>> BITSFUNC(fake_sections) *out,
>>>         if (!copy)
>>>                 return;
>>>
>>> -       if (out->count >= out->max_count)
>>> -               fail("too many copied sections (max = %d)\n",
>>> out->max_count);
>>> +       if (out->count > out->max_count)
>>> +               fail("too many copied sections (max = %d, need = %d)\n",
>>> +                    out->max_count, out->count);
>>>
>>
>> I think the old test was correct: we haven't incremented count yet
>> (it's a couple lines below), so count is the zero-based index to which
>> we're writing.
>>
>> I thought of doing the need = %d thing, but I think that the output is
>> a foregone conclusion: count == max_count + 1 when this fails.  A list
>> of all the section names would be more interesting, but eu-readelf -S
>> will tell is that.
>>
>
> Well, I have reproduced this failure.  eu-readelf output included.

It's branch profiling.  Patches coming.

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
