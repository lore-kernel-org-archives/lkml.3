Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaKFVCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:02:35 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47780 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKFVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:02:31 -0500
Message-ID: <545BE1DE.6060900@linaro.org>
Date: Thu, 06 Nov 2014 22:02:22 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>, Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: (bisected) Lock up on sh73a0/kzm9g on cpuidle initialization
References: <CAMuHMdXaaa2t6+sH2egGacVxkAPeTUkAgwdYsOnMnEPnuLdB5Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXaaa2t6+sH2egGacVxkAPeTUkAgwdYsOnMnEPnuLdB5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 09:38 PM, Geert Uytterhoeven wrote:
> When CONFIG_CPU_IDLE=y, the kernel locks up during cpuidle initialization
> on Renesas sh73a0/kzm9g-reference, which has a dual-core Cortex-A9.
>
> Last message is:
>
>      DMA: preallocated 256 KiB pool for atomic coherent allocations
>
> After this it's supposed to print:
>
>      cpuidle: using governor ladder
>      cpuidle: using governor menu
>
> I've bisected this to commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
> ("sched: Let the scheduler see CPU idle states").
>
> Reverting that commit, and commit 83a0a96a5f26d974580fd7251043ff70c8f1823d
> ("sched/fair: Leverage the idle state info when choosing the "idlest"
> cpu") which
> depends on it, fixes the problem.
>
> I saw the discussion "lockdep splat in CPU hotplug", so I enabled lockdep
> debugging, but didn't see a lockdep splat.

Did you try the fix attached ?

https://lkml.org/lkml/2014/10/22/722

> I'm using CONFIG_TREE_RCU=y, as this is SMP without PREEMPT.
>
> Anyone with a clue?




>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

