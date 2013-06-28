Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3F1QHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:07:20 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50155 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3F1QHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:07:15 -0400
Date: Fri, 28 Jun 2013 18:07:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Fixup for removing -f option in perf record
Message-ID: <20130628160711.GA4389@gmail.com>
References: <1372307120-737-1-git-send-email-namhyung@kernel.org>
 <20130627093609.GO28407@twins.programming.kicks-ass.net>
 <20130627103931.GA5534@gmail.com>
 <20130627104750.GB27378@dyad.programming.kicks-ass.net>
 <20130628094738.GA28751@krava.brq.redhat.com>
 <51CD9AE4.6060307@gmail.com>
 <20130628153736.GA462@gmail.com>
 <51CDB3CB.8040304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CDB3CB.8040304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 6/28/13 9:37 AM, Ingo Molnar wrote:
> >
> >* David Ahern <dsahern@gmail.com> wrote:
> >
> >>On 6/28/13 3:47 AM, Jiri Olsa wrote:
> >>>>>I thought -f was the implied default for ages?
> >>>>
> >>>>OK.. I've been dutifully typing it all this while :-)
> >>>
> >>>The '-f' option in record command had no affect.. myabe it got
> >>>depreceated when we started to backup perf.data to perf.data.old..?
> >>
> >>Way back in 2010, 2.6.34 kernel - 7865e817 commit. I've been typing
> >>the -f for while too. Now about the need for the pesky -f on the
> >>analysis side....
> >
> >That's only needed when perf.data is owned by a different user, right?
> >
> 
> Yes, why not let file permissions dictate of uid x can read uid y files? 
> Why does perf need to have that restriction? For example, QA collects 
> the data files, developers analyze them.

So, the thinking behind that is that user should not be able to
generate a malicious perf.data file and let root (or another user)
run it accidentally.

( That presumes some sort of exploitable parsing bug or other buffer 
  overflow in perf. )

I don't feel terribly strongly about it though.

Thanks,

	Ingo
