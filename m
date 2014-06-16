Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaFPJLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbaFPJLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:11:44 -0400
Date: Mon, 16 Jun 2014 11:11:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Clean up format of args in jbd2
 plugin
Message-ID: <20140616091139.GC8312@krava.brq.redhat.com>
References: <20140612204144.018410d4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612204144.018410d4@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 08:41:44PM -0400, Steven Rostedt wrote:
> While synchronizing what's in trace-cmd vs what's in perf, I came
> across a change that was made when entering the jbd2 plugin into
> the tools/lib/traceevent directory. For example, one of the function
> prototypes went from:
> 
> unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
> 					    unsigned long long *args)
> 
> to:
> 
> static unsigned long long
> process_jbd2_dev_to_name(struct trace_seq *s,
> 			 unsigned long long *args)
> 
> I can understand the line break after the long long, but there's no
> reason to keep args on a separate line.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

queued, thanks

jirka

> ---
> diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
> index 0db714c..5c23d5b 100644
> --- a/tools/lib/traceevent/plugin_jbd2.c
> +++ b/tools/lib/traceevent/plugin_jbd2.c
> @@ -30,8 +30,7 @@
>  #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
>  
>  static unsigned long long
> -process_jbd2_dev_to_name(struct trace_seq *s,
> -			 unsigned long long *args)
> +process_jbd2_dev_to_name(struct trace_seq *s, unsigned long long *args)
>  {
>  	unsigned int dev = args[0];
>  
> @@ -40,8 +39,7 @@ process_jbd2_dev_to_name(struct trace_seq *s,
>  }
>  
>  static unsigned long long
> -process_jiffies_to_msecs(struct trace_seq *s,
> -			 unsigned long long *args)
> +process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
>  {
>  	unsigned long long jiffies = args[0];
>  
