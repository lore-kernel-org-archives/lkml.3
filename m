Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3KKQbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:31:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38361 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3KKQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:30:55 -0500
Date: Mon, 11 Nov 2013 17:30:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com,
        mingo@redhat.com
Subject: Re: [PATCH v3 0/2] ARC: Add perf support for ARC700 cores
Message-ID: <20131111163042.GA10977@twins.programming.kicks-ass.net>
References: <1383832512-21130-1-git-send-email-mjonker@synopsys.com>
 <20131111162755.GC26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111162755.GC26898@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 05:27:55PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 07, 2013 at 02:55:10PM +0100, Mischa Jonker wrote:
> > Hi all,
> > 
> > Please find v3 of my attempt to add support for perf for ARC700 PMU's. If
> > possible, it would be nice to get some feedback on the implementation from
> > non-ARC/Synopsys people familiar with the perf subsystem in Linux.
> 
> Anything in particular you wanted feedback on? It looks like a fairly
> straight fwd thingy.

Ah, so its one of those that cannot sample; you might want to fail when
we try and create a sampling event.

Also, you could consider running an (hr)timer to periodically update the
events so that you don't miss a hardware counter wrap around -- if that
is a distinct possibility.

