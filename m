Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaLTUmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:42:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42361 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaLTUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:42:15 -0500
Date: Sat, 20 Dec 2014 21:42:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: rostedt@goodmis.org, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftracetest: Replace usleep with sleep 0.000001
Message-ID: <20141220204213.GA16705@amd>
References: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418186307-1259-1-git-send-email-mpe@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-12-10 15:38:27, Michael Ellerman wrote:
> usleep is a Fedoraism, it's not generally available on Debian based
> systems AFAICS.
> 
> GNU sleep accepts a floating point argument, so use that instead.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Could ftrace user interface be enhanced not to need random delays?

								Pavel

> ---
>  tools/testing/selftests/ftrace/test.d/event/event-enable.tc     | 6 +++---
>  tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/ftrace/test.d/event/event-enable.tc b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
> index 668616d9bb03..c5343add3407 100644
> --- a/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
> +++ b/tools/testing/selftests/ftrace/test.d/event/event-enable.tc
> @@ -21,7 +21,7 @@ reset_tracer
>  do_reset
>  
>  echo 'sched:sched_switch' > set_event
> -usleep 1
> +sleep 0.000001
>  
>  count=`cat trace | grep sched_switch | wc -l`
>  if [ $count -eq 0 ]; then
> @@ -31,7 +31,7 @@ fi
>  do_reset
>  
>  echo 1 > events/sched/sched_switch/enable
> -usleep 1
> +sleep 0.000001
>  
>  count=`cat trace | grep sched_switch | wc -l`
>  if [ $count -eq 0 ]; then
> @@ -41,7 +41,7 @@ fi
>  do_reset
>  
>  echo 0 > events/sched/sched_switch/enable
> -usleep 1
> +sleep 0.000001
>  
>  count=`cat trace | grep sched_switch | wc -l`
>  if [ $count -ne 0 ]; then
> diff --git a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
> index 655c415b6e7f..84a2020d4e7b 100644
> --- a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
> +++ b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
> @@ -21,7 +21,7 @@ reset_tracer
>  do_reset
>  
>  echo 'sched:*' > set_event
> -usleep 1
> +sleep 0.000001
>  
>  count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
>  if [ $count -lt 3 ]; then
> @@ -31,7 +31,7 @@ fi
>  do_reset
>  
>  echo 1 > events/sched/enable
> -usleep 1
> +sleep 0.000001
>  
>  count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
>  if [ $count -lt 3 ]; then
> @@ -41,7 +41,7 @@ fi
>  do_reset
>  
>  echo 0 > events/sched/enable
> -usleep 1
> +sleep 0.000001
>  
>  count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
>  if [ $count -ne 0 ]; then

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
