Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbaLJXGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:06:33 -0500
Received: from ozlabs.org ([103.22.144.67]:60146 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbaLJXGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:06:31 -0500
Message-ID: <1418252789.26146.0.camel@ellerman.id.au>
Subject: Re: [PATCH] powerpc: secondary CPUs signal to master before setting
 active and online (fixes kernel BUG at kernel/smpboot.c:134!)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Paul Mackerras <paulus@samba.org>
Date: Thu, 11 Dec 2014 10:06:29 +1100
In-Reply-To: <CA+55aFyR5PzNkojvEej1NXnpEFOPOYfnxCcPDAjg1rE79tQv7A@mail.gmail.com>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
	 <20141208083408.GA8023@gmail.com> <20141208211859.6e81ec81@kryten>
	 <20141209105819.0e847b4b@kryten>
	 <CA+55aFyR5PzNkojvEej1NXnpEFOPOYfnxCcPDAjg1rE79tQv7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 12:54 -0800, Linus Torvalds wrote:
> On Mon, Dec 8, 2014 at 3:58 PM, Anton Blanchard <anton@samba.org> wrote:
> > Hi Ingo,
> >
> >> At that point I thought the previous task_cpu() was somewhat ingrained
> >> in the scheduler and came up with the patch. If not, we could go on a
> >> hunt to see what else needs fixing.
> >
> > I had another look. The scheduled does indeed make assumptions about the
> > previous task_cpu, but we have a hammer to fix it up called
> > select_fallback_rq.
> >
> > I annotated select_fallback_rq, and did hit a case where the CPU was
> > not active. ppc64 patch below.
> 
> Anton, I'll assume I will get this through the usual powerpc pull requests?

Yeah I'll put it in my tree unless Anton objects.

cheers


