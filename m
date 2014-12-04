Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaLDADB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:03:01 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:52120 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLDADA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:03:00 -0500
Message-ID: <547FA4B1.6050200@linaro.org>
Date: Wed, 03 Dec 2014 19:02:57 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: William Cohen <wcohen@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steve Capper <steve.capper@linaro.org>
CC: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com> <547C36DB.7060903@hitachi.com> <547F242D.1060705@redhat.com> <547F94B0.1000902@linaro.org>
In-Reply-To: <547F94B0.1000902@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 17:54, David Long wrote:
> On 12/03/14 09:54, William Cohen wrote:
>> On 12/01/2014 04:37 AM, Masami Hiramatsu wrote:
>>> (2014/11/29 1:01), Steve Capper wrote:

[...]

>>>> That would explain why the state of play of the interrupts is in an
>>>> unexpected state in the crash I reported:
>>>> "The point of failure in the panic was:
>>>> fs/buffer.c:1257
>>>>
>>>> static inline void check_irqs_on(void)
>>>> {
>>>> #ifdef irqs_disabled
>>>>          BUG_ON(irqs_disabled());
>>>> #endif
>>>> }
>>>> "
>>>>
>>>> This is all new to me so I'm still at the head-scratching stage.
>>>
>>> Ah, I see.
>>>
>>> Thank you,
>>>
>>>>
>>>> David,
>>>> Does the above make sense to you? Have you managed to reproduce the
>>>> crash I get?
>>>>
>>>> Cheers,
>>>> --
>>>> Steve
>
> I have easily produced a crash although it doesn't look to me like the
> same one.  I'm getting a NULL pointer dereference.  The PMU stuff (used
> by perf record|stat -e) should be quite independent of kprobes though.
>
> -dl
>

Oops, never mind the above bit.  I see this is not PMU-related, but use 
of kprobes through perf.  My bad.

-dl

