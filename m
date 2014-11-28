Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaK1QBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:01:18 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:39471 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaK1QBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:01:16 -0500
MIME-Version: 1.0
In-Reply-To: <5476BFB4.2020705@hitachi.com>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
	<20141120135851.GA32528@linaro.org>
	<54759041.9080105@hitachi.com>
	<20141126100325.GA9157@linaro.org>
	<5476120D.9030703@linaro.org>
	<CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com>
	<5476BFB4.2020705@hitachi.com>
Date: Fri, 28 Nov 2014 16:01:15 +0000
Message-ID: <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com>
Subject: Re: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
From: Steve Capper <steve.capper@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Long <dave.long@linaro.org>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        William Cohen <wcohen@redhat.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 06:07, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2014/11/27 3:59), Steve Capper wrote:
>> The crash is extremely easy to reproduce.
>>
>> I've not observed any missed events on a kprobe on an arm64 system
>> that's still alive.
>> My (limited!) understanding is that this suggests there could be a
>> problem with how missed events from a recursive call to memcpy are
>> being handled.
>
> I think so too. BTW, could you bisect that? :)
>

I can't bisect, but the following functions look suspicious to me
(again I'm new to kprobes...):
kprobes_save_local_irqflag
kprobes_restore_local_irqflag

I think these are breaking somehow when nested (i.e. from a recursive probe).

That would explain why the state of play of the interrupts is in an
unexpected state in the crash I reported:
"The point of failure in the panic was:
fs/buffer.c:1257

static inline void check_irqs_on(void)
{
#ifdef irqs_disabled
        BUG_ON(irqs_disabled());
#endif
}
"

This is all new to me so I'm still at the head-scratching stage.

David,
Does the above make sense to you? Have you managed to reproduce the crash I get?

Cheers,
--
Steve
