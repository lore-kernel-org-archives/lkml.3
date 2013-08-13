Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab3HMV4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:56:08 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:50391 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758094Ab3HMV4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:56:07 -0400
Date: Tue, 13 Aug 2013 17:57:16 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
In-Reply-To: <20130813160043.GB5280@gmail.com>
Message-ID: <alpine.DEB.2.02.1308131749330.9154@pianoman.cluster.toy>
References: <20130805081641.GA24808@gmail.com> <20130805082320.GA9562@infradead.org> <20130805083132.GE26746@gmail.com> <20130805083434.GA20606@infradead.org> <20130805090857.GA26940@gmail.com> <20130806061932.GA20485@infradead.org> <20130812181956.GB19405@gmail.com>
 <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy> <20130813104821.GB2170@gmail.com> <20130813121141.GB2188@ghostprotocols.net> <20130813160043.GB5280@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020A.520AAB75.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Ingo Molnar wrote:

> 
> that can only be addressed by either extending 'perf test' or by testing 
> libpfm et al sooner. The upstream kernel can only address regressions that 
> get reported.

Most of the tests in my test-suite are reactive.  Meaning, I wrote them 
after an ABI-breaking change was reported elsewhere, and I needed a small 
test case for bisection purposes.  Thus they are good for finding if a 
corner of the perf ABI re-breaks but they're not great at spotting new 
breakages.

Writing a complete test suite for something as complicated as the 
perf-event ABI is impractical.  One thing you can do is require anyone 
submitting new functionality also provide a regression test, but
I don't see that happening.

Another issue is that despite having some ABI definitions for files in 
/sys, these are broken with impunity.  And I've yet to have an 
ABI-breaking changeset reverted based on my bug reports.  So you can see 
why I'm not really motivated to even bother trying, as it seems like it 
would be pointless busy work at this point.

It would just be nice if we just straight out say "the ABI is whatever 
lets the perf tool run.  Anything else is undefined behavior and shouldn't 
be relied on".

Vince
