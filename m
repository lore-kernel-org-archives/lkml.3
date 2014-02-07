Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaBGMCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:02:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58948 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbaBGMCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:02:08 -0500
Date: Fri, 7 Feb 2014 12:01:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: Torvald Riegel <triegel@redhat.com>
Cc: Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140207120124.GF5976@mudshark.cambridge.arm.com>
References: <20140206134825.305510953@infradead.org>
 <21984.1391711149@warthog.procyon.org.uk>
 <52F3DA85.1060209@arm.com>
 <20140206185910.GE27276@mudshark.cambridge.arm.com>
 <1391720965.23421.3884.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391720965.23421.3884.camel@triegel.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Torvald,

It looks like Paul clarified most of the points I was trying to make
(thanks Paul!), so I won't go back over them here.

On Thu, Feb 06, 2014 at 09:09:25PM +0000, Torvald Riegel wrote:
> Are you familiar with the formalization of the C11/C++11 model by Batty
> et al.?
> http://www.cl.cam.ac.uk/~mjb220/popl085ap-sewell.pdf
> http://www.cl.cam.ac.uk/~mjb220/n3132.pdf
> 
> They also have a nice tool that can run condensed examples and show you
> all allowed (and forbidden) executions (it runs in the browser, so is
> slow for larger examples), including nice annotated graphs for those:
> http://svr-pes20-cppmem.cl.cam.ac.uk/cppmem/

Thanks for the link, that's incredibly helpful. I've used ppcmem and armmem
in the past, but I didn't realise they have a version for C++11 too.
Actually, the armmem backend doesn't implement our atomic instructions or
the acquire/release accessors, so it's not been as useful as it could be.
I should probably try to learn OCaml...

> IMHO, one thing worth considering is that for C/C++, the C11/C++11 is
> the only memory model that has widespread support.  So, even though it's
> a fairly weak memory model (unless you go for the "only seq-cst"
> beginners advice) and thus comes with a higher complexity, this model is
> what likely most people will be familiar with over time.  Deviating from
> the "standard" model can have valid reasons, but it also has a cost in
> that new contributors are more likely to be familiar with the "standard"
> model.

Indeed, I wasn't trying to write-off the C11 memory model as something we
can never use in the kernel. I just don't think the current situation is
anywhere close to usable for a project such as Linux. If a greater
understanding of the memory model does eventually manifest amongst C/C++
developers (by which I mean, the beginners advice is really treated as
such and there is a widespread intuition about ordering guarantees, as
opposed to the need to use formal tools), then surely the tools and libraries
will stabilise and provide uniform semantics across the 25+ architectures
that Linux currently supports. If *that* happens, this discussion is certainly
worth having again.

Will
