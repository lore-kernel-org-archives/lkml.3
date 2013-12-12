Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LLIDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:03:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:47496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3LLID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 03:03:29 -0500
Date: Thu, 12 Dec 2013 00:03:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212080314.GA25783@infradead.org>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
 <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> The wait_queue is a swiss army knife and in most of the cases the
> full complexity is not needed.  Here we provide a slim version, as
> it lowers memory consumption and runtime overhead.

Might it make more sense to just make the simple one the default and use
the complex one in the few cases that need it?

It would also be good to enumerate those cases.  The wake callbacks come
to mind, but I guess there are more?

