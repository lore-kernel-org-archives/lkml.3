Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaFDTrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:47:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaFDTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:47:36 -0400
Date: Wed, 4 Jun 2014 21:47:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, fweisbec@gmail.com, tglx@linutronix.de,
        hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp, ipi: Speed up IPI handling by invoking the
 callbacks in reverse order
Message-ID: <20140604194731.GO13930@laptop.programming.kicks-ass.net>
References: <20140604193934.21321.19185.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604193934.21321.19185.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 01:09:35AM +0530, Srivatsa S. Bhat wrote:
> The current implementation of lockless list (llist) has a drawback: if we
> want to traverse the list in FIFO order (oldest to newest), we need to
> reverse the list first (and this can be expensive if the list is large,
> since this is an O(n) operation).

Have you actually looked at the queue depth of this thing? Large queues
are a problem for interrupt latency.
