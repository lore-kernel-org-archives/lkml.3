Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbaCLGtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:49:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbaCLGtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:49:11 -0400
Date: Wed, 12 Mar 2014 07:49:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Bohac <jbohac@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: is printk() safe within a timekeeper_seq write section?
Message-ID: <20140312064902.GK30956@twins.programming.kicks-ass.net>
References: <20140306174531.GA30634@midget.suse.cz>
 <531F6429.8050008@linaro.org>
 <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de>
 <531F8605.10003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531F8605.10003@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 02:54:13PM -0700, John Stultz wrote:
> Ok, so a generic solution is probably not going to be worth it then. My
> thought was that since we do a very limited amount of informational
> printks in the timekeeping code, we can be fairly safe delaying the
> print-out until we drop the locks.
> 
> For timekeeping, its really 4 call sites:
> * invalid inject_sleep_time deltas
> * > 11% clocksource freq adjustments
> * insert leap second
> * delete leap second
> 

There is the printk_sched() you can reuse; you might want to change the
name and the generic [sched_delayed] prefix it gets though.
