Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaAGRaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:30:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:5338 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaAGRaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:30:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,619,1384329600"; 
   d="scan'208";a="463009415"
Message-ID: <1389115801.3040.105.camel@empanada>
Subject: Re: [PATCH 0/2] tracing/triggers: A couple minor variable name
 changes
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Date: Tue, 07 Jan 2014 11:30:01 -0600
In-Reply-To: <20140106223124.0e5fd0b4@gandalf.local.home>
References: <cover.1389036657.git.tom.zanussi@linux.intel.com>
	 <20140106161347.4cc82a4b@gandalf.local.home>
	 <1389055673.3040.83.camel@empanada>
	 <20140106205034.53c219cc@gandalf.local.home>
	 <1389063069.3040.90.camel@empanada>
	 <20140106223124.0e5fd0b4@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 22:31 -0500, Steven Rostedt wrote:
> On Mon, 06 Jan 2014 20:51:09 -0600
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> > I'll run the next version through my 'testsuite', which unfortunately is
> > still manual (one of the many things on my todo list is automate it)..
> 
> I have some basic tests, attached is one. Which failed. Here's the
> patch that fixes it:
> 
> -- Steve
> 
> tracing: Fix counter for traceon/off event triggers
> 
> The counters for the traceon and traceoff are only suppose to decrement
> when the trigger enables or disables tracing. It is not suppose to decrement
> every time the event is hit.
> 
> Only decrement the counter if the trigger actually did something.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>

> ---
>  kernel/trace/trace_events_trigger.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index f6dd115..a53e0da 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -742,13 +742,16 @@ traceon_trigger(struct event_trigger_data *data)
>  static void
>  traceon_count_trigger(struct event_trigger_data *data)
>  {
> +	if (tracing_is_on())
> +		return;
> +
>  	if (!data->count)
>  		return;
>  
>  	if (data->count != -1)
>  		(data->count)--;
>  
> -	traceon_trigger(data);
> +	tracing_on();
>  }
>  
>  static void
> @@ -763,13 +766,16 @@ traceoff_trigger(struct event_trigger_data *data)
>  static void
>  traceoff_count_trigger(struct event_trigger_data *data)
>  {
> +	if (!tracing_is_on())
> +		return;
> +
>  	if (!data->count)
>  		return;
>  
>  	if (data->count != -1)
>  		(data->count)--;
>  
> -	traceoff_trigger(data);
> +	tracing_off();
>  }
>  
>  static int


