Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaFPJLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbaFPJLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:11:23 -0400
Date: Mon, 16 Jun 2014 11:11:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Clean up format of args in
 cfg80211 plugin
Message-ID: <20140616091117.GB8312@krava.brq.redhat.com>
References: <20140612194420.24073744@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612194420.24073744@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 07:44:20PM -0400, Steven Rostedt wrote:
> While synchronizing what's in trace-cmd vs what's in perf, I came
> across a change that was made when entering the cfg80211 plugin into
> the tools/lib/traceevent directory. The function prototype went from:
> 
> static unsigned long long process___le16_to_cpup(struct trace_seq *s,
> 						 unsigned long long *args)
> 
> to:
> 
> static unsigned long long
> process___le16_to_cpup(struct trace_seq *s,
> 		       unsigned long long *args)
> 
> I can understand the line break after the long long, but there's no
> reason to keep args on a separate line.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

queued, thanks

jirka

> ---
> diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
> index c066b25..4592d84 100644
> --- a/tools/lib/traceevent/plugin_cfg80211.c
> +++ b/tools/lib/traceevent/plugin_cfg80211.c
> @@ -5,8 +5,7 @@
>  #include "event-parse.h"
>  
>  static unsigned long long
> -process___le16_to_cpup(struct trace_seq *s,
> -		       unsigned long long *args)
> +process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
>  {
>  	uint16_t *val = (uint16_t *) (unsigned long) args[0];
>  	return val ? (long long) le16toh(*val) : 0;
