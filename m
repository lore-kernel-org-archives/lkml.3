Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991Ab3LIQY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:24:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64743 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934003Ab3LIQYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:24:53 -0500
Date: Mon, 9 Dec 2013 11:24:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls
 from parse-filter.c
Message-ID: <20131209112449.47eeedaa@gandalf.local.home>
In-Reply-To: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Dec 2013 14:33:57 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> This patchset tries to remove all die() calls in event filter parsing
> code.  The only remaining bits are in trace-seq.c which implement
> print functions and I want to hear what's the best way we can handle
> the error case during the print.
> 
> I also put this patches on libtraceevent/die-removal-v1 branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> 
> Any comments are welcome, thanks
> Namhyung
> 

Other than what I commented on, the rest can have my:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Namhyung Kim (14):
>   tools lib traceevent: Get rid of malloc_or_die() in show_error()
>   tools lib traceevent: Get rid of die in add_filter_type()
>   tools lib traceevent: Get rid of malloc_or_die() in
>     pevent_filter_alloc()
>   tools lib traceevent: Get rid of malloc_or_die() allocate_arg()
>   tools lib traceevent: Get rid of malloc_or_die() in read_token()
>   tools lib traceevent: Get rid of malloc_or_die() in find_event()
>   tools lib traceevent: Get rid of malloc_or_die() in add_event()
>   tools lib traceevent: Get rid of die() in create_arg_item()
>   tools lib traceevent: Get rid of die() in add_right()
>   tools lib traceevent: Get rid of die() in reparent_op_arg()
>   tools lib traceevent: Get rid of malloc_or_die() in
>     pevent_filter_add_filter_str()
>   tools lib traceevent: Get rid of die() in
>     pevent_filter_clear_trivial()
>   tools lib traceevent: Refactor test_filter() to get rid of die()
>   tools lib traceevent: Get rid of die() in some string conversion
>     funcitons
> 
>  tools/lib/traceevent/event-parse.h  |   3 +-
>  tools/lib/traceevent/parse-filter.c | 432 +++++++++++++++++++++++++-----------
>  2 files changed, 303 insertions(+), 132 deletions(-)
> 

