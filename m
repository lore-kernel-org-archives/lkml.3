Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaDVNT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaDVNTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:19:53 -0400
Date: Tue, 22 Apr 2014 15:19:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Fix backward compatibility macros
 for pevent filter enums
Message-ID: <20140422131938.GE1104@krava.brq.redhat.com>
References: <20140421222346.0351ced4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421222346.0351ced4@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 10:23:46PM -0400, Steven Rostedt wrote:
> 
> The return value for pevent_filter_match() is suppose to return FILTER_NONE
> if the event doesn't have a filter, and FILTER_NOEXIST if there is no filter
> at all. But the change 41e12e580a7 "tools lib traceevent: Refactor
> pevent_filter_match() to get rid of die()" replaced the return value
> with PEVENT_ERRNO__* values and added "backward compatibility" macros
> that used the old names. Unfortunately, the NOEXIST and NONE macros were
> swapped, and this broke users that use the old return names.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  tools/lib/traceevent/event-parse.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 9c38181..d6c610a 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -886,8 +886,8 @@ struct event_filter {
>  struct event_filter *pevent_filter_alloc(struct pevent *pevent);
>  
>  /* for backward compatibility */
> -#define FILTER_NONE		PEVENT_ERRNO__FILTER_NOT_FOUND
> -#define FILTER_NOEXIST		PEVENT_ERRNO__NO_FILTER
> +#define FILTER_NONE		PEVENT_ERRNO__NO_FILTER
> +#define FILTER_NOEXIST		PEVENT_ERRNO__FILTER_NOT_FOUND
>  #define FILTER_MISS		PEVENT_ERRNO__FILTER_MISS
>  #define FILTER_MATCH		PEVENT_ERRNO__FILTER_MATCH
>  
> -- 
> 1.8.1.4
> 
