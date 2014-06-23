Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaFWSsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:48:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaFWSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:48:18 -0400
Date: Mon, 23 Jun 2014 20:47:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, Jason Low <jason.low2@hp.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
Message-ID: <20140623184757.GG13930@laptop.programming.kicks-ass.net>
References: <1402948127.2970.578.camel@schen9-DESK>
 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
 <20140623162234.GP5714@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623162234.GP5714@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 06:22:34PM +0200, Andi Kleen wrote:
> > So I don't get why we can't do the below; I think Jason tried to ask the
> > same...
> 
> The important part for performance is to minimize the cache line transfers. Your
> unconditional variant would cause more dirty cache lines than Tim's,
> right?

Don't think so. We already have the overloaded thing on stack and dirty,
and the only thing it needs is rq->nr_running and we already
unconditionally load that.
