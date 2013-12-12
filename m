Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3LLOzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:55:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:35164 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374Ab3LLOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:55:35 -0500
Date: Thu, 12 Dec 2013 09:55:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212095533.1fab411f@gandalf.local.home>
In-Reply-To: <52A9CCA6.6040806@windriver.com>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
	<1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
	<20131212080314.GA25783@infradead.org>
	<alpine.DEB.2.02.1312121147130.28330@ionos.tec.linutronix.de>
	<52A9CCA6.6040806@windriver.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 09:48:06 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
 
> 1) git mv wait.[ch] --- > cwait.[ch]
>    make an empty wait.h include cwait.h temporarily
> 
> 2) rename all existing functions in cwait.[ch] to have an added
>   "c" prefix (or similar)
>    
>    in wait.h, temporarily add a bunch of things like
>           #define wait_xyz  cwait_xyz
>    so that things still compile and link.

What about instead change all users of wait_*() to cwait_*().

Then the next steps would be to skip 3 and jump right to 4)

> 
> 3) track down the users who really need the extra complexity
>    and have them use cwait calls and include cwait.h
> 
> 4) bring in the simple wait queue support as wait.c and wait.h
>    and delete the defines added in step two.  This will be the
>    flag day commit.

Not a flag day commit, as no one is using it. Then start converting all
users back to the wait_*() functions one at a time. If something
breaks, we know which one it was.

-- Steve

> 
> Is that what we want to do here?
> 
