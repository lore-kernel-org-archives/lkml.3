Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaBMJiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:38:07 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45548 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaBMJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:38:03 -0500
Date: Thu, 13 Feb 2014 10:38:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
Message-ID: <20140213093800.GA6078@gmail.com>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
 <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> This is a strawman proposal to simplify the idle implementation, eliminate
> a race
> 
> Benefits over current code:
>  - ttwu_queue_remote doesn't use an IPI unless needed

Cool.

>  - The diffstat should speak for itself :)

Neat!

>  - Less racy.  Spurious IPIs are possible, but only in narrow windows or
>    when two wakeups occur in rapid succession.
>  - Seems to work (?)
> 
> Issues:
>  - Am I doing the percpu stuff right?
>  - Needs work on non-x86 architectures

Absolutely, and with the least amount of disruption possible, as 
people are not very good at testing 'all' of them.

>  - The !CONFIG_SMP case needs to be checked

Which also happens to be the default for half of all non-x86 arches.

>  - Is "idlepoll" a good name for the new code?  It doesn't have *that*
>    much to do with the idle state.  Maybe cpukick?

'cpukick', hands down.

> If this turns out okay, TIF_NEED_RESCHED could possibly be deleted as well.

Cool ...

Thanks,

	Ingo
