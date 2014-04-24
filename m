Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaDXKII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:08:08 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754284AbaDXKIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:08:05 -0400
Message-ID: <5358E27F.2000206@nod.at>
Date: Thu, 24 Apr 2014 12:07:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 17/28] nios2: Signal handling support
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<1397824031-4892-14-git-send-email-lftan@altera.com>	<CAFLxGvyPCwo-d92QK9qAR5=gmRS4p24tYs9PiOApBGfrKdxJ5Q@mail.gmail.com> <CAFiDJ5-q5hzR+1BDCmCzwqbuVZOUdjX_-omR4u3rnC8xqdQZLA@mail.gmail.com>
In-Reply-To: <CAFiDJ5-q5hzR+1BDCmCzwqbuVZOUdjX_-omR4u3rnC8xqdQZLA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2014 12:01, schrieb Ley Foon Tan:
> On Sun, Apr 20, 2014 at 3:29 AM, Richard Weinberger
 >>> +
>>> +       push_cache((unsigned long) &frame->retcode);
>>> +
>>> +       /* Set up registers for signal handler */
>>> +       regs->sp = (unsigned long) frame;
>>> +       regs->r4 = (unsigned long) (current_thread_info()->exec_domain
>>> +                       && current_thread_info()->exec_domain->signal_invmap
>>> +                       && sig < 32
>>> +                       ? current_thread_info()->exec_domain->signal_invmap[sig]
>>> +                       : sig);
>>
>> Does nios2 really need signal translation and supports execution domains?
> Nios2 have one default "default_exec_domain" only. So, we can change
> this to "regs->r4 = sig;".

Nice.

> BTW, most of the architectures have similar code.

Yep, because everyone is copy&pasting from each others without thinking. 8)
There is already a cleanup going on: https://lkml.org/lkml/2014/3/2/198

Thanks,
//richard
