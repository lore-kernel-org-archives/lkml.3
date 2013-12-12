Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3LLK5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:57:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:39360 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3LLK5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:57:21 -0500
Date: Thu, 12 Dec 2013 11:56:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
In-Reply-To: <20131212080314.GA25783@infradead.org>
Message-ID: <alpine.DEB.2.02.1312121147130.28330@ionos.tec.linutronix.de>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com> <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com> <20131212080314.GA25783@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Christoph Hellwig wrote:

> On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > The wait_queue is a swiss army knife and in most of the cases the
> > full complexity is not needed.  Here we provide a slim version, as
> > it lowers memory consumption and runtime overhead.
> 
> Might it make more sense to just make the simple one the default and use
> the complex one in the few cases that need it?

Sure.
 
> It would also be good to enumerate those cases.  The wake callbacks come
> to mind, but I guess there are more?

You can convert everything which uses default_wake_function and does
not use the exclusive wait trickery.

Thanks,

	tglx
