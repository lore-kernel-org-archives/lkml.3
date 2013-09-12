Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3ILQ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:57:39 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33632 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3ILQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:57:38 -0400
Date: Thu, 12 Sep 2013 18:57:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vince@deater.net>, Andi Kleen <ak@linux.intel.com>,
        acme@infradead.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org,
        trinity@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Message-ID: <20130912165733.GA23698@gmail.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723225150.GT6123@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> > 
> > I hate having to justify why breaking the ABI is unacceptable.
> 
> Well it's a testing ABI, so we can do changes to it.
> 
> I hope you're not suggesting that perf cannot be extended anymore.

It obviously should remain extensible, limiting it to 'config' is rather 
stupid. If a parser sees something it cannot parse it should ignore that 
event.

Your feature to export 'precise' requirements on events looks useful to 
me. We could implement it not by special casing it implicitly but by 
saying that if ../format/precise contains something like:

   attr:240-241

then that's a natural extension of the config:X-Y format and should be 
interpreted to mean mean 2 bits in the perf attr field. I.e. we could go 
beyond the config bitfield.

Basically the whole perf_event_attr can be thought of as a 'giant 
bitfield', in which we can specify values to export an enumerated list of 
events from the kernel to tooling.

(Using attr:X-Y the config and config1 variants can be expressed as well, 
as the config fields are inside the attr structure.)

The positions within the perf_attr are an ABI, so this would work pretty 
well.

Thanks,

	Ingo
