Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaIQOSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:18:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58823 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaIQOSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:18:23 -0400
Date: Wed, 17 Sep 2014 16:18:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140917141816.GO2840@worktop.localdomain>
References: <20140914055450.GB296@x4>
 <CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
 <20140915163740.GA12408@x4>
 <20140916105547.GA1205@quack.suse.cz>
 <20140916144252.GB32118@x4>
 <20140916111331.14303381@gandalf.local.home>
 <20140916203510.GF1205@quack.suse.cz>
 <20140916170709.73ef2993@gandalf.local.home>
 <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916173328.6306a5c2@gandalf.local.home>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 05:33:28PM -0400, Steven Rostedt wrote:

> >   printk_deffered() will be in order with other printks after your commit
> > 458df9fd4815b47809875d57f42e16401674b621. Just printing to console itself
> > will be delayed to the next timer interrupt. Or am I missing something?
> 
> Hehe, you're right. I blame the meds for forgetting this.
> 
> Yeah, my update will put the data in order. Thus I guess I agree with
> your assessment. We probably don't need the "sched_delayed" anymore.
> 
> OK, you convinced me, but I still like to hear Peter's view on this
> before we commit it.

By not calling console_unlock() the messages will be 'delayed', as in,
we'll not call console->write() and we'll not see them, etc..

So some form of [delayed] or whatnot seems to remain appropriate.

I agree that the 'sched_' part has lived far beyond its relevance.
