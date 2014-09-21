Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaIUUds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 16:33:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33195 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaIUUdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 16:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <541F2BCD.2040007@linux.intel.com>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
	<1411313216-2641-3-git-send-email-minipli@googlemail.com>
	<541F2BCD.2040007@linux.intel.com>
Date: Sun, 21 Sep 2014 22:33:45 +0200
Message-ID: <CA+rthh_UJWqeTJP9aewuC0HRo9wnucy5GScqYH0=0ob=bn4nBw@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] x86, ptdump: Simplify page flag evaluation code
From: Mathias Krause <minipli@googlemail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 September 2014 21:49, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 9/21/2014 8:26 AM, Mathias Krause wrote:
>>
>> -               if (pr & _PAGE_PCD)
>> -                       pt_dump_cont_printf(m, dmsg, "PCD ");
>> -               else
>> -                       pt_dump_cont_printf(m, dmsg, "    ");
>> +               pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" :
>> "");
>
>
> while you have some nice cleanups in your patch, I can't say I consider this
> an improvement.
> Yes the C standard allows ? to be used like this
> but no, I don't think it improves readability in general.

Not in general, but in this case, it does, IMHO.

> (I think for me the main exception is NULL pointer cases, but this is not
> one of these)

Apparently such a pattern (using the question mark operator combined
with a bit test to choose string constants) is used quite often in the
linux kernel as a simple grep tells me (probably catches a few false
positives but still a representative number):

$ git grep '[^&]&[^&].*? *"' | wc -l
2668

And, honestly, the bit test combined with the question mark operator
makes the code way more readable for me. It not only makes the code
more compact (1 instead of 4 lines). It also allows to have the common
parts written only once and thereby removing the possibility of having
them conflict with each other, e.g. make them generate strings of
different lengths.

Would you prefer the bit test to be surrounded by braces to make it
more easy to understand? Even though, the operator precedence is
clearly defined by the C standard for this case, so no braces are
needed.


Thanks,
Mathias
