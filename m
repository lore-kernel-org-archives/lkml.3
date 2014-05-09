Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbaEIUwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:52:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:50907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbaEIUv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:51:59 -0400
Date: Fri, 9 May 2014 22:51:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 06/20] arch,avr32: Fold atomic_ops
Message-ID: <20140509205155.GH1429@laptop.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.049922584@infradead.org>
 <20140509183241.GA4491@samfundet.no>
 <20140509204309.GA13467@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140509204309.GA13467@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 10:43:09PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2014 at 08:32:41PM +0200, Hans-Christian Egtvedt wrote:

> > > -	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
> > > -		result = atomic_sub_return(-i, v);
> > 
> > I do not recall why we did it like this any more, I would assume both sub and
> > add to be single cycle instructions.

Similarly, can I rip out atomic_sub_unless() ?
