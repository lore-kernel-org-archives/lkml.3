Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3CSO77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:59:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4132 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab3CSO76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:59:58 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Jlu5nvpyoosA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=dwZyKuPOOjEA:10 a=-p4YWH2EONuYmNkEYYIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363705197.5938.31.camel@gandalf.local.home>
Subject: Re: [PATCH 3/9] perf util: Get rid of write_or_die() from
 trace-event-info.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 10:59:57 -0400
In-Reply-To: <1363704594.22553.56.camel@laptop>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-4-git-send-email-namhyung@kernel.org>
	 <1363703711.5938.20.camel@gandalf.local.home>
	 <1363704594.22553.56.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 15:49 +0100, Peter Zijlstra wrote:
> On Tue, 2013-03-19 at 10:35 -0400, Steven Rostedt wrote:
> > What about:
> >         int err = 0;
> > 
> >         err += tracing_data_header();
> >         err += read_header_files();
> >         [...]
> > 
> >         if (err < 0) {
> >                 free(tdata);
> >                 tdata = NULL;
> >         }
> > 
> > Also, is the only clean up needed be freeing tdata?
> 
> I always use err |= foo() and if (err) but I suppose it doesn't matter
> the original error codes are lost both ways which doesn't seem to be a
> problem here.

err |= foo() is fine too. Both are better that err1, err2, err3, ...,
errN :-)

-- Steve


