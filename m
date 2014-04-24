Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaDXKRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:17:35 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754353AbaDXKRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:17:32 -0400
Message-ID: <5358E4B9.1050308@nod.at>
Date: Thu, 24 Apr 2014 12:17:29 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 17/28] nios2: Signal handling support
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<1397824031-4892-14-git-send-email-lftan@altera.com>	<CAFLxGvyPCwo-d92QK9qAR5=gmRS4p24tYs9PiOApBGfrKdxJ5Q@mail.gmail.com>	<CAFiDJ5-q5hzR+1BDCmCzwqbuVZOUdjX_-omR4u3rnC8xqdQZLA@mail.gmail.com> <CAFiDJ59g0E+hoREriydqk2uBsDvchPMSQi6NCgnwOd64OGLJ0w@mail.gmail.com>
In-Reply-To: <CAFiDJ59g0E+hoREriydqk2uBsDvchPMSQi6NCgnwOd64OGLJ0w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2014 12:13, schrieb Ley Foon Tan:
> On Thu, Apr 24, 2014 at 6:01 PM, Ley Foon Tan <lftan@altera.com> wrote:
>> On Sun, Apr 20, 2014 at 3:29 AM, Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>>
>>>> +
>>>> +       /* Default to using normal stack.  */
>>>> +       usp = regs->sp;
>>>> +
>>>> +       /* This is the X/Open sanctioned signal stack switching.  */
>>>> +       if ((ka->sa.sa_flags & SA_ONSTACK) && (current->sas_ss_sp != 0)) {
>>>> +               if (!on_sig_stack(usp))
>>>> +                       usp = current->sas_ss_sp + current->sas_ss_size;
>>>> +       }
>>>
>>> You can use sigsp() here.
>> Okay.
>>
> I just noticed that sigsp() have struct ksignal argument. We can use
> sigsp() for nios2 because it doesn't have struct ksignal.
> 
> unsigned long sigsp(unsigned long sp, struct ksignal *ksig);

Did you at look at the struct ksignal definition and the clean series I've
pointed you to?

Thanks,
//richard
