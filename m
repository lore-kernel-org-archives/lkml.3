Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKGH7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:59:31 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63671 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaKGH72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:59:28 -0500
MIME-Version: 1.0
In-Reply-To: <545BE1DE.6060900@linaro.org>
References: <CAMuHMdXaaa2t6+sH2egGacVxkAPeTUkAgwdYsOnMnEPnuLdB5Q@mail.gmail.com>
	<545BE1DE.6060900@linaro.org>
Date: Fri, 7 Nov 2014 08:59:25 +0100
X-Google-Sender-Auth: gUU8_dKScnKuyzpc4XQGEwRXu-o
Message-ID: <CAMuHMdXQr65g4He0D0ZRN923OJ2A7WNgwbiTru_1dGWnvbvCJA@mail.gmail.com>
Subject: Re: (bisected) Lock up on sh73a0/kzm9g on cpuidle initialization
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Nov 6, 2014 at 10:02 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 11/06/2014 09:38 PM, Geert Uytterhoeven wrote:
>> When CONFIG_CPU_IDLE=y, the kernel locks up during cpuidle initialization
>> on Renesas sh73a0/kzm9g-reference, which has a dual-core Cortex-A9.
>>
>> Last message is:
>>
>>      DMA: preallocated 256 KiB pool for atomic coherent allocations
>>
>> After this it's supposed to print:
>>
>>      cpuidle: using governor ladder
>>      cpuidle: using governor menu
>>
>> I've bisected this to commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
>> ("sched: Let the scheduler see CPU idle states").
>>
>> Reverting that commit, and commit 83a0a96a5f26d974580fd7251043ff70c8f1823d
>> ("sched/fair: Leverage the idle state info when choosing the "idlest"
>> cpu") which
>> depends on it, fixes the problem.
>>
>> I saw the discussion "lockdep splat in CPU hotplug", so I enabled lockdep
>> debugging, but didn't see a lockdep splat.
>
> Did you try the fix attached ?
>
> https://lkml.org/lkml/2014/10/22/722

Thanks, I didn't try that.

However, this patch seems to be in v3.18-rc3, so I'm already using it.
Hence it doesn't fix the problem for me.

On another board, with a dual Cortex-A15, the problem doesn't show up.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
