Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab3IPJh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:37:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IPJh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:37:28 -0400
Date: Mon, 16 Sep 2013 11:37:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130916093719.GR21832@twins.programming.kicks-ass.net>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
 <20130913105637.GM31370@twins.programming.kicks-ass.net>
 <20130913141638.GA6799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913141638.GA6799@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 10:16:38AM -0400, Dave Jones wrote:
> without the diff, it'll use all kinds of fds. this diff hardwires it to just use
> fd's from perf_event_open.  I'll hack up a command line switch to do this in a better
> way at some point.
> 
> 	Dave
> 
> 
> diff --git a/fds.c b/fds.c
> index cc1ca6d..f48c95e 100644
> --- a/fds.c
> +++ b/fds.c
> @@ -119,6 +119,8 @@ static int get_new_random_fd(void)
>  retry:
>  	i = rand() % 6;
>  
> +	i = 3;
> +
>  	if (do_specific_proto == TRUE)
>  		i = 1;

I'm just not having much luck it seems, even after actually enabling
list debugging (D0H).

What kind of hardware are you running this on?
