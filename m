Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3AKGDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:03:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab3AKGDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:03:40 -0500
Message-ID: <1357884213.5716.35.camel@marge.simpson.net>
Subject: Re: kernel BUG at kernel/sched_rt.c:493!
From: Mike Galbraith <bitbucket@online.de>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org
Date: Fri, 11 Jan 2013 07:03:33 +0100
In-Reply-To: <1357881760.5716.31.camel@marge.simpson.net>
References: <20130105174632.GB19226@u1004.rgmadvisors.com>
	 <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
	 <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
	 <20130108143605.GB5594@home.goodmis.org>
	 <20130108150153.GA2219@BohrerMBP.rgmadvisors.com>
	 <1357791191.5841.8.camel@marge.simpson.net>
	 <20130110195809.GA3415@BohrerMBP.rgmadvisors.com>
	 <1357881760.5716.31.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:0p25vfenQS09NRQAP8lfPehJpJQSK4LHlmeFlRrdWDQ
 CjRAKDWlzGRjkJAe59t4Q/+6oqp6QQOUURNv23auBnAxy+cO1F
 r37X/xQ8ff3ZWiPbEPXwfuhe5vsZlxJhzRP6gduLMA2NYjClOB
 2vYXG16fgupqM5mH7HZ265ly1OXoajTCCCWOIiaRjxiI8I6pSq
 scTQ94JgFhQyvpGUtkYtuUF2preqPIao5B9IOXifzQCp1C+6oH
 wB0Rypl9aANaV0TUwxOllPI74kHflGGDZ7CM+7Av1tdeb8n19y
 3Duqreg9w0XgCPcIj+ugucyxzE6R2mFZEK3wh8OoGyC6cLyh35
 jSyPZRUc5HpVrYOxsvHy9ns20WX//EsRB2w+pT5ij2y8XsvLV0
 MPsNej4I65Wjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 06:22 +0100, Mike Galbraith wrote: 
> On Thu, 2013-01-10 at 13:58 -0600, Shawn Bohrer wrote:
> 
> > Here is the output:
> > 
> > [   81.278842] SysRq : Changing Loglevel
> > [   81.279027] Loglevel set to 9
> > [   83.285456] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
> > [   85.286452] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
> > [   85.289625] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
> > [   87.287435] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
> > [   87.290718] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
> > [   89.288469] Initial want: -50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1000000000
> > [   89.291550] Initial want: 150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 800000000
> > [   89.292940] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
> > [   89.294082] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
> > [   89.295194] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
> > [   89.296274] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
> > [   90.959004] [sched_delayed] sched: RT throttling activated
> > [   91.289470] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
> > [   91.292767] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
> > [   91.294037] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
> > [   91.295364] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
> > [   91.296355] BUG triggered, want: 200000000
> > [   91.296355] 
> > [   91.296355] rt_rq[7]:
> > [   91.296355]   .rt_nr_running                 : 0
> > [   91.296355]   .rt_throttled                  : 0
> > [   91.296355]   .rt_time                       : 0.000000
> > [   91.296355]   .rt_runtime                    : 750.000000
> > [   91.307332] Initial want: -50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1000000000
> > [   91.308440] Initial want: -100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1050000000
> > [   91.309586] Initial want: -150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1100000000
> > [   91.310716] Initial want: -200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1150000000
> > [   91.311707] BUG triggered, want: -200000000
> > [   91.311707] 
> > [   91.311707] rt_rq[6]:
> > [   91.311707]   .rt_nr_running                 : 1
> > [   91.311707]   .rt_throttled                  : 0
> > [   91.311707]   .rt_time                       : 307.209987
> > [   91.311707]   .rt_runtime                    : 1150.000000
> 
> That makes about as much sense as my crash did.  There is no leak, but
> cpu found nada.  So rd/span is changing on us?

So I looked at the locking (yet again), and (for the umpteenth time) see
no way in the world that can happen.  Hrmph.

-Mike

