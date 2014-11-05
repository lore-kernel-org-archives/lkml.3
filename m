Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKEWxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:53:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:6728 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751002AbaKEWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:53:52 -0500
Date: Wed, 5 Nov 2014 17:53:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2 v3] ftracetest: Add a couple of ftrace test cases
Message-ID: <20141105175350.1224c304@gandalf.local.home>
In-Reply-To: <5459E2AB.8020009@hitachi.com>
References: <20141104152845.521858531@goodmis.org>
	<20141104153028.602754370@goodmis.org>
	<87zjc6ulry.fsf@sejong.aot.lge.com>
	<5459E2AB.8020009@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014 17:41:15 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/11/05 16:52), Namhyung Kim wrote:
> > Hi Steve,
> > 
> > On Tue, 04 Nov 2014 10:28:47 -0500, Steven Rostedt wrote:
> >> +count=`cat trace | grep '()' | grep -v schedule | wc -l`
> >> +
> >> +if [ $count -ne 0 ]; then
> >> +    echo "Graph filtering not working after stack tracer disabled?"
> >> +    exit -1
> >> +fi
> >> +
> >> +count=`cat trace | grep 'schedule()' | wc -l` 
> >> +if [ $count -eq 0 ]; then
> >> +    echo "No schedule traces found?"
> >> +    exit -1
> > 
> > Hmm.. in this case don't we need to call do_reset especially for the
> > last testcase?  Maybe we could define a simple function like:
> > 
> > fail() { # msg
> > 	do_reset
> > 	echo $1
> > 	exit -1
> > }
> 
> If you want to call do_reset always on exit, you can also use "trap do_reset 0" too.

Cool, I didn't know that. But I like the "fail" command, as it is a bit
more verbose.

I'll update.

Thanks,

-- Steve

