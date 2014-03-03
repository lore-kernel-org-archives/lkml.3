Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaCCU1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:27:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaCCU1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:27:42 -0500
Date: Mon, 3 Mar 2014 15:26:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140303202644.GG25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
 <20140228194642.GM25953@redhat.com>
 <1393621411.2899.39.camel@buesod1.americas.hpqcorp.net>
 <20140303150531.GZ25953@redhat.com>
 <20140303172316.GA22728@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303172316.GA22728@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:23:16PM +0100, Andi Kleen wrote:
> > Hmm, so based on Andi's reply, I am assuming you are running on a Westmere
> > (or Nehalem) due to the lack of mem-stores.
> > 
> > If you don't have mem-stores, this tool isn't going to work.  The tool can
> > only detect contention when sampling reads _and_ writes to the same
> > addresses.
> 
> On these CPUs you could simply sample on HITM. You won't get addresses,
> but at least IPs and call stacks.

Heh.  I never thought about that.  And sure enough a quick test with
mem-stores commented out produced the same results (minus the stores).

One would just have to 'figure' out what cacheline offsets are causing the
HITMs.

Cheers,
Don
