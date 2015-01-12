Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbbALPh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:37:58 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbbALPh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:37:57 -0500
Date: Mon, 12 Jan 2015 16:37:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC 1/4] lockdep: additional lock specific information when
 dumping locks
Message-ID: <20150112153747.GE25256@twins.programming.kicks-ass.net>
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
 <20150112150633.GD25256@twins.programming.kicks-ass.net>
 <54B3E466.2030006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B3E466.2030006@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:12:38AM -0500, Sasha Levin wrote:
> The reason for my patch is simple: 

That might have maybe been good changelog material?

> I'm fuzzing with hundreds of worker threads
> which at some point trigger a complete system lockup for some reason.
> 
> When lockdep dumps the list of held locks it shows that pretty much every one
> of those threads is holding the lock which caused the lockup, which is incorrect
> because it considers locks in the process of getting acquired as "held".
> 
> This is my solution to that issue. I wanted to know which one of the threads is
> really holding the lock rather than just waiting on it.
> 
> Is there a better way to solve that problem?

Sure, think moar, if the accompanying stack trace is in the middle
of the blocking primitive, ignore the top held lock ;-)

Alternatively, make better/more use of lock_acquired() and track the
acquire vs acquired information in the held_lock (1 bit) and look at it
when printing.
