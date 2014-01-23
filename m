Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaAWNch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:32:37 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41396 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAWNcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140123094804.GP30183@twins.programming.kicks-ass.net>
References: <20140122123022.GN31570@twins.programming.kicks-ass.net>
	<20140122131456.GA389@x4>
	<52DFD50E.800@oracle.com>
	<20140122183538.GA389@x4>
	<20140122184253.GN30183@twins.programming.kicks-ass.net>
	<20140122190905.GA391@x4>
	<20140122191254.GA390@x4>
	<20140122201605.GU11314@laptop.programming.kicks-ass.net>
	<20140122210814.GC9481@laptop.programming.kicks-ass.net>
	<20140122211740.GA391@x4>
	<20140123094804.GP30183@twins.programming.kicks-ass.net>
Date: Thu, 23 Jan 2014 08:32:35 -0500
X-Google-Sender-Auth: wAKAq6WctmgclDwkb3Vr4vV-UUs
Message-ID: <CA+5PVA64VFUrXo9rAEW0KBGZDmohppvh_q=ZA5SLpiS0B1Fkmw@mail.gmail.com>
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 4:48 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jan 22, 2014 at 10:17:40PM +0100, Markus Trippelsdorf wrote:
>> Yes. Thanks Peter.
>>
>
> Ah much simpler patch that should have the same effect:

This fixes the issue on my baremetal i7 machine as well.

josh

> ---
> Subject: sched/x86/tsc: Initialize multiplier to 0
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 22 Jan 2014 22:08:14 +0100
>
> Since we keep the clock value linearly continuous on frequency change,
> make sure the initial multiplier is 0, such that out initial value is
> 0. Without this we compute the initial value at whatever the TSC has
> managed to reach since power-on.
>
> Fixes: 20d1c86a57762 ("sched/clock, x86: Rewrite cyc2ns() to avoid the need to disable IRQs")
> Cc: lenb@kernel.org
> Cc: rjw@rjwysocki.net
> Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> Cc: rui.zhang@intel.com
> Cc: jacob.jun.pan@linux.intel.com
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: hpa@zytor.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: dyoung@redhat.com
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/kernel/tsc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -180,7 +180,7 @@ static void cyc2ns_write_end(int cpu, st
>
>  static void cyc2ns_data_init(struct cyc2ns_data *data)
>  {
> -       data->cyc2ns_mul = 1U << CYC2NS_SCALE_FACTOR;
> +       data->cyc2ns_mul = 0;
>         data->cyc2ns_shift = CYC2NS_SCALE_FACTOR;
>         data->cyc2ns_offset = 0;
>         data->__count = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
