Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3KAOZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:25:18 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:41294 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KAOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:25:17 -0400
Date: Fri, 1 Nov 2013 14:24:49 +0000
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 08/14] perf report: Cache cumulative callchains
Message-ID: <20131101142449.GA3372@sdfg.com.ar>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
 <1383202576-28141-9-git-send-email-namhyung@kernel.org>
 <20131031111333.GB27863@sdfg.com.ar>
 <87r4b04n2t.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4b04n2t.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:07:22PM +0900, Namhyung Kim wrote:
> Hi Rodrigo,
> 
> On Thu, 31 Oct 2013 11:13:34 +0000, Rodrigo Campos wrote:
> > On Thu, Oct 31, 2013 at 03:56:10PM +0900, Namhyung Kim wrote:
> >> @@ -538,6 +586,7 @@ iter_finish_cumulative_entry(struct add_entry_iter *iter,
> >>  	evsel->hists.stats.total_period += sample->period;
> >>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> >>  
> >> +	free(iter->priv);
> >
> > And here I'm seeing a double free when trying the patchset with other examples.
> > I added a printf to the "if (node == NULL)" case and I'm hitting it. So it seems
> > to me that, when reusing the entry, every user is freeing it and then the double
> > free.
> >
> > This is my first time looking at perf code, so I might be missing LOT of things,
> > sorry in advance :)
> 
> Don't say sorry!  You're very helpful and found a real bug!

:-)


> > I'm not really sure which is the fix for this. Also just in case I tried
> > assigning "iter->priv = NULL" after it's free'd and it """fixes""" it.
> 
> I think the right fix is assigning "iter->priv = NULL" as you said.  But
> I changed this patch a bit for v3 so need to check it again.

Ohh, great. I'll wait for v3 to play more with this :-)





Thanks a lot,
Rodrigo
