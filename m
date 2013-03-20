Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159Ab3CTB7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:59:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15374 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab3CTB7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:59:03 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FVc5S2mYZKgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=-PlxAUMR4MkA:10 a=yGbAVU1Q76W6_vTxM7EA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363744741.6345.4.camel@gandalf.local.home>
Subject: Re: [PATCH 7/9] perf util: Get rid of read_or_die() in
 trace-event-read.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 21:59:01 -0400
In-Reply-To: <87a9pyj227.fsf@sejong.aot.lge.com>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-8-git-send-email-namhyung@kernel.org>
	 <1363704867.5938.28.camel@gandalf.local.home>
	 <87a9pyj227.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 10:24 +0900, Namhyung Kim wrote:

> >> @@ -61,8 +61,10 @@ static int do_read(int fd, void *buf, int size)
> >>  		if (repipe) {
> >>  			int retw = write(STDOUT_FILENO, buf, ret);
> >>  
> >> -			if (retw <= 0 || retw != ret)
> >> -				die("repiping input file");
> >> +			if (retw <= 0 || retw != ret) {
> >> +				pr_debug("repiping input file");
> >
> > Again, why debug and not err?
> 
> Well, there's a pr_err() at the caller of top-level trace_report() in
> case of error.  So if we use pr_err() there'll be multiple error message
> for one failure and I don't think it's so helpful to normal users.  If
> one really wants to know what happens inside, she will set -v to see
> this low-level debug message.
> 
> Does that make sense?
> 

I haven't looked at the context of all the changes as to where they are
called from. I'm fine if we have a methodology of having pr_err() at the
top level and pr_debug() within the nested code. It looked to me that
the choices were somewhat random, but then again, I was missing context
to the code.

As long as a pr_err() that gives the user enough information to know
what went wrong is displayed, I'm fine with other errors using
pr_debug().

-- Steve


