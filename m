Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaAOOtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:49:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaAOOtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:49:31 -0500
Date: Wed, 15 Jan 2014 15:48:42 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/6] perf, tools: Support handling complete branch stacks
 as histograms v3
Message-ID: <20140115144842.GA17358@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389661461-18996-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:04:17PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Currently branch stacks can be only shown as edge histograms for
> individual branches. I never found this display particularly useful.
> 
> This implements an alternative mode that creates histograms over complete
> branch traces, instead of individual branches, similar to how normal
> callgraphs are handled. This is done by putting it in
> front of the normal callgraph and then using the normal callgraph
> histogram infrastructure to unify them.
> 
> This way in complex functions we can understand the control flow
> that lead to a particular sample, and may even see some control
> flow in the caller for short functions.
> 
> Example (simplified, of course for such simple code this
> is usually not needed):
> 
> tcall.c:
> 
> volatile a = 10000, b = 100000, c;
> 
> __attribute__((noinline)) f2()
> {
> 	c = a / b;
> }
> 
> __attribute__((noinline)) f1()
> {
> 	f2();
> 	f2();
> }
> main()
> {
> 	int i;
> 	for (i = 0; i < 1000000; i++)
> 		f1();
> }
> 
> % perf record -b -g ./tsrc/tcall
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
> % perf report --branch-history

this option is not added in this patch, I tried:
  $ perf report --call-graph=fractal,0.5,callee,function,branch

but as I already said in reply for patch 3, it's not working
please update the doc in Documentation/perf-report.txt with an example

jirka
