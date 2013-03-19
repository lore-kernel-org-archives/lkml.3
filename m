Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3CSOuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:50:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3CSOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:50:03 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=c2tSGNMr5iYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=SbTfxjnowbEA:10 a=FPED7kTb3Ku3Sq9_8fQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363704602.5938.26.camel@gandalf.local.home>
Subject: Re: [PATCH 6/9] perf util: Get rid of malloc_or_die() in
 trace-event-read.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 10:50:02 -0400
In-Reply-To: <1363683224-28804-7-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-7-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
>  	free(version);
> @@ -331,11 +354,12 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
>  
>  	page_size = read4(pevent);
>  
> -	read_header_files(pevent);
> -	read_ftrace_files(pevent);
> -	read_event_files(pevent);
> -	read_proc_kallsyms(pevent);
> -	read_ftrace_printk(pevent);
> +	if (read_header_files(pevent) ||
> +	    read_ftrace_files(pevent) ||
> +	    read_event_files(pevent) ||
> +	    read_proc_kallsyms(pevent) ||
> +	    read_ftrace_printk(pevent))
> +		goto out;

I think I like the err += func() and check for err < 0, better.

-- Steve

>  
>  	size = calc_data_size - 1;
>  	calc_data_size = 0;


