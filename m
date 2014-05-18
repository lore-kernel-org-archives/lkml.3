Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaERIgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 04:36:52 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54525 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaERIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 04:36:45 -0400
Message-ID: <1400402201.5166.13.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 18 May 2014 10:36:41 +0200
In-Reply-To: <20140518052039.GF4570@linux.vnet.ibm.com>
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
	 <20140514154459.GE4570@linux.vnet.ibm.com>
	 <1400123931.5175.38.camel@marge.simpson.net>
	 <1400386954.5140.36.camel@marge.simpson.net>
	 <20140518052039.GF4570@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-17 at 22:20 -0700, Paul E. McKenney wrote:

> If you are saying that turning on nohz_full doesn't help unless you
> also ensure that there is only one runnable task per CPU, I completely
> agree.  If you are saying something else, you lost me.  ;-)

Yup, that's it more or less.  It's not only single task loads that could
benefit from better isolation, but if isolation improving measures are
tied to nohz_full, other sensitive loads will suffer if they try to use
isolation improvements.

-Mike

