Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab3AWMUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:20:52 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:36763 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab3AWMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:20:51 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUV-e51Fg2xvhxz5Wvjj-g=tyft56eNmF9ZGrnJzkL+wUQ@mail.gmail.com>
References: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
	<CA+icZUXzQgxBokwOmyx5+e8rLNCkoz6ea=YoPA7=BT+iENWj8g@mail.gmail.com>
	<CAFTL4hzmf9ZLb4=QjpGFXT96EwOyRSFbqBD0VjLgKYaZGrBzYg@mail.gmail.com>
	<CA+icZUV-e51Fg2xvhxz5Wvjj-g=tyft56eNmF9ZGrnJzkL+wUQ@mail.gmail.com>
Date: Wed, 23 Jan 2013 13:20:50 +0100
Message-ID: <CAFTL4hxW96Q=MDFmMw8dtJGY0yT6w0uEc20gB46oTEJuefbTSQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc4-nohz3
From: Frederic Weisbecker <fweisbec@gmail.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
> On Wed, Jan 23, 2013 at 1:11 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> 2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>>> On Wed, Jan 23, 2013 at 12:19 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> Hi Frederic,
>>>>
>>>> I wanted to 3.8-rc4-nohz3 [1] here on my Ubuntu/precise AMD64 system.
>>>>
>>>> Unfortunately, the build breaks like this:
>>>>
>>>> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
>>>> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>>>>
>>>
>>> Looks like you tested with CONFIG_KVM=y (as module fails!).
>>
>> Yep. looks like I forgot some EXPORT_SYMBOL().
>>
>
> Hmmm, that was my first thought, too, but about...
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c243b81..fff0932 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5713,7 +5713,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>         if (req_immediate_exit)
>                 smp_send_reschedule(vcpu->cpu);
>
> -       kvm_guest_enter();
> +       guest_enter();
>
>         if (unlikely(vcpu->arch.switch_db_regs)) {
>                 set_debugreg(0, 7);

Yeah, guest_enter and guest_exit need an EXPORT_SYMBOL() in
kernel/context_tracking.c such that the module can find these
functions.
