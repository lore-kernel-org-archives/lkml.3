Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbaCDJnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:43:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbaCDJm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:42:56 -0500
Date: Tue, 4 Mar 2014 10:42:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140304094236.GN9987@twins.programming.kicks-ass.net>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
 <20140303150531.GZ25953@redhat.com>
 <20140303172316.GA22728@two.firstfloor.org>
 <20140303202644.GG25953@redhat.com>
 <20140303213625.GC22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303213625.GC22728@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 10:36:25PM +0100, Andi Kleen wrote:
> > Heh.  I never thought about that.  And sure enough a quick test with
> > mem-stores commented out produced the same results (minus the stores).
> > 
> > One would just have to 'figure' out what cacheline offsets are causing the
> > HITMs.
> 
> Often that can be determined statically from the instruction (register-offset)
> 
> However keep in mind that there is some skid so the instruction may not
> be correct.

Even with the real_ip pebs field? I thought the whole purpose of that
was to tag the actual instruction matching the event.
