Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab3FCTsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:48:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34792 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3FCTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:48:12 -0400
Date: Mon, 3 Jun 2013 21:48:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/8] vtime: Use consistent clocks among nohz accounting
Message-ID: <20130603194806.GC31107@somewhere>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
 <1369065716-22801-3-git-send-email-fweisbec@gmail.com>
 <51AC6625.3080000@message-id.invalid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AC6625.3080000@message-id.invalid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:47:17AM +0200, Stefan Seyfried wrote:
> Am 20.05.2013 18:01, schrieb Frederic Weisbecker:
> > While computing the cputime delta of dynticks CPUs,
> > we are mixing up clocks of differents natures:
> 
> [...]
> 
> > As a consequence, some strange behaviour with unstable tsc
> > has been observed such as non progressing constant zero cputime.
> > (The 'top' command showing no load).
> 
> This happens for example on my trusty ThinkPad X200s (family 6 model 23
> stepping 10 Core 2 duo), seriously confusing its user (me :-).
> 
> > Fix this by only using local_clock(), or its irq safe/remote
> > equivalent, in vtime code.
> > 
> > Reported-by: Mike Galbraith <efault@gmx.de>
> > Suggested-by: Mike Galbraith <efault@gmx.de>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> FWIW:
> Tested-by: Stefan Seyfried <seife+dev@b1-systems.com>
> 
> This patch fixes the 0% CPU issue on openSUSE Factory kernels for me.

Thanks! The patch has been committed already so I can't add your Tested-by:
but feedbacks on testing are always appeciated.
