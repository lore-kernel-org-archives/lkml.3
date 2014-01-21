Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaAUR1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:27:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaAUR1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:27:51 -0500
Date: Tue, 21 Jan 2014 18:27:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] lockdep: pack subclass/trylock/read/check into a
	single argument
Message-ID: <20140121172737.GA24896@redhat.com>
References: <20140120181942.GA20783@redhat.com> <20140120182019.GA26515@redhat.com> <20140121141022.GX31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121141022.GX31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Peter Zijlstra wrote:
>
> I tried the below but filed to see my vmlinux shrink, maybe I'm just not
> building the right kernel, or otherwise GCC is stupid.

...

> +struct lockdep_acquire_flags {
> +	unsigned long subclass : 3;
> +	unsigned long trylock  : 1;
> +	unsigned long read     : 2;
> +	unsigned long check    : 1;
> +};

Yes, I tried this too. I do see the difference, but the result is worse:

	- 5262832
	+ 5256987

looks like, gcc is not smart enough...

Oleg.

