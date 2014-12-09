Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaLIUyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:54:46 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53173 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaLIUyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:54:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141209105819.0e847b4b@kryten>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
	<20141208083408.GA8023@gmail.com>
	<20141208211859.6e81ec81@kryten>
	<20141209105819.0e847b4b@kryten>
Date: Tue, 9 Dec 2014 12:54:43 -0800
X-Google-Sender-Auth: 8r8V_tILjcd4qzry0tkXKjNSqw0
Message-ID: <CA+55aFyR5PzNkojvEej1NXnpEFOPOYfnxCcPDAjg1rE79tQv7A@mail.gmail.com>
Subject: Re: [PATCH] powerpc: secondary CPUs signal to master before setting
 active and online (fixes kernel BUG at kernel/smpboot.c:134!)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, yuyang.du@intel.com,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Daniel J Blueman <daniel@numascale.com>, subbaram@codeaurora.org,
        Brian Norris <computersforpeace@gmail.com>,
        Slava Pestov <sp@datera.io>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, mpe@ellerman.id.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 3:58 PM, Anton Blanchard <anton@samba.org> wrote:
> Hi Ingo,
>
>> At that point I thought the previous task_cpu() was somewhat ingrained
>> in the scheduler and came up with the patch. If not, we could go on a
>> hunt to see what else needs fixing.
>
> I had another look. The scheduled does indeed make assumptions about the
> previous task_cpu, but we have a hammer to fix it up called
> select_fallback_rq.
>
> I annotated select_fallback_rq, and did hit a case where the CPU was
> not active. ppc64 patch below.

Anton, I'll assume I will get this through the usual powerpc pull requests?

> I think x86 have a similar (although harder to hit) issue.

Ingo?

                         Linus
