Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab3HNOUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:20:47 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:61377 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3HNOUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:20:45 -0400
Date: Wed, 14 Aug 2013 16:20:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Vince Weaver <vince@deater.net>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130814142041.GA16087@gmail.com>
References: <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org>
 <20130812181956.GB19405@gmail.com>
 <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
 <20130813104821.GB2170@gmail.com>
 <20130813121141.GB2188@ghostprotocols.net>
 <20130813160043.GB5280@gmail.com>
 <alpine.DEB.2.02.1308131749330.9154@pianoman.cluster.toy>
 <20130814141301.GA2138@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814141301.GA2138@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Aug 13, 2013 at 05:57:16PM -0400, Vince Weaver escreveu:
> > On Tue, 13 Aug 2013, Ingo Molnar wrote:
> >
> > > that can only be addressed by either extending 'perf test' or by 
> > > testing libpfm et al sooner. The upstream kernel can only address 
> > > regressions that get reported.
>  
> > Most of the tests in my test-suite are reactive.  Meaning, I wrote 
> > them after an ABI-breaking change was reported elsewhere, and I needed 
> > a small test case for bisection purposes.  Thus they are good for 
> > finding if a corner of the perf ABI re-breaks but they're not great at 
> > spotting new breakages.

Would be nice to merge those in into 'perf test' - reactive tests are 
useful as well IMO.

> > Writing a complete test suite for something as complicated as the 
> > perf-event ABI is impractical.  One thing you can do is require anyone 
> > submitting new functionality also provide a regression test, but
> 
> Agreed.
> 
> > I don't see that happening.
> 
> See some of Namhyung, Adrian and Jiri recent patchsets, they came with 
> 'perf test' regression tests.

That's good progress indeed! If we merge in the cases that Vince found 
then we'd have good practical coverage and we could also start requiring 
good testcases for every new ABI extension.

That method distributes the overhead of having to write it to those who 
want to extend (and, statistically speaking, inadvertantlybreak!) the ABI.

Thanks,

	Ingo
