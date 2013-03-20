Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3CTByi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:54:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3CTByh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:54:37 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=s5RgfaFXP7gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=vcfcUXAzZI4A:10 a=BUhKDa4HkDfaUFyo9FEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363744474.6345.0.camel@gandalf.local.home>
Subject: Re: [PATCH 5/9] perf util: Handle failure case in trace_report()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 21:54:34 -0400
In-Reply-To: <87ip4mj2ly.fsf@sejong.aot.lge.com>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-6-git-send-email-namhyung@kernel.org>
	 <1363704473.5938.25.camel@gandalf.local.home>
	 <87ip4mj2ly.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 10:12 +0900, Namhyung Kim wrote:

> >> +++ b/tools/perf/util/trace-event-read.c
> >> @@ -293,7 +293,10 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
> >>  	int show_version = 0;
> >>  	int show_funcs = 0;
> >>  	int show_printk = 0;
> >> -	ssize_t size;
> >> +	ssize_t size = -1;
> >> +	struct pevent *pevent;
> >> +
> >> +	*ppevent = NULL;
> >>  
> >>  	calc_data_size = 1;
> >>  	repipe = __repipe;
> >> @@ -317,34 +320,38 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
> >>  	file_bigendian = buf[0];
> >>  	host_bigendian = bigendian();
> >>  
> >> -	*ppevent = read_trace_init(file_bigendian, host_bigendian);
> >> -	if (*ppevent == NULL)
> >> -		die("read_trace_init failed");
> >> +	pevent = read_trace_init(file_bigendian, host_bigendian);
> >> +	if (pevent == NULL) {
> >
> > Shouldn't we still set *ppevent to NULL? Or will the user now need to
> > make sure that its pevent is NULL and always check for error?
> 
> I thought it's impossible to check return value for error since we don't
> know how large a tracing data is, so I decided to init *ppevent to NULL
> at the beginning and set it to a valid pevent right before return.  Thus
> user need to check NULL before using it.
> 
> In the above case of perf_event__process_tracing_data(), it's a pipe
> mode and we can know its size since it's saved in a temp file.
> 

My fault, I missed the addition of *ppevent = NULL at the beginning.
Ignore this comment.

-- Steve


