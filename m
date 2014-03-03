Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaCCTs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:48:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50238 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaCCTs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:48:58 -0500
Date: Mon, 3 Mar 2014 20:48:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Mario <jmario@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Davidlohr Bueso <davidlohr@hp.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303194839.GD6835@laptop.programming.kicks-ass.net>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
 <20140303150531.GZ25953@redhat.com>
 <20140303172316.GA22728@two.firstfloor.org>
 <5314C4C4.1020304@redhat.com>
 <20140303184117.GL9987@twins.programming.kicks-ass.net>
 <20140303185819.GB22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303185819.GB22728@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 07:58:19PM +0100, Andi Kleen wrote:
> Haswell is best however because it can report addresses on far more
> events.

Sure; however I think the code to data structure mapping might be more
useful still. Its very hard to map a random address into a heap and find
a fitting data structure. You'd need some allocator with a reverse map,
which to me seems like too much overhead for normal runtime use.
