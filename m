Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3F1JsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3F1JsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:48:12 -0400
Date: Fri, 28 Jun 2013 11:47:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
Message-ID: <20130628094738.GA28751@krava.brq.redhat.com>
References: <1372307120-737-1-git-send-email-namhyung@kernel.org>
 <20130627093609.GO28407@twins.programming.kicks-ass.net>
 <20130627103931.GA5534@gmail.com>
 <20130627104750.GB27378@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627104750.GB27378@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 12:47:50PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 27, 2013 at 12:39:31PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, Jun 27, 2013 at 01:25:20PM +0900, Namhyung Kim wrote:
> > > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > > 
> > > > The commit bf3da4014a0c ("perf record: Remove -f/--force option") got
> > > > rid of -f option from perf record.  But this option was used
> > > > internally by various sub-commands so they wouldn't work anymore.
> > > > Also update the example document not to use -f option.
> > > 
> > > Oh man.. we got rid of -f? Do we now default to over-write existing data
> > > file?
> > 
> > I thought -f was the implied default for ages?
> 
> OK.. I've been dutifully typing it all this while :-)

The '-f' option in record command had no affect.. myabe it got
depreceated when we started to backup perf.data to perf.data.old..?

The report command bails out on following condition:

        if (!force && input_stat.st_uid && (input_stat.st_uid != geteuid())) {

jirka
