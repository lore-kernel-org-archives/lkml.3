Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3KEW1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:27:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:2877 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755716Ab3KEW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:27:50 -0500
Date: Tue, 5 Nov 2013 17:27:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing: Update event filters for multibuffer
Message-ID: <20131105172745.2ebbd6ba@gandalf.local.home>
In-Reply-To: <f16e9ce4270c62f46b2e966119225e1c3cca7e60.1382620672.git.tom.zanussi@linux.intel.com>
References: <cover.1382620672.git.tom.zanussi@linux.intel.com>
	<f16e9ce4270c62f46b2e966119225e1c3cca7e60.1382620672.git.tom.zanussi@linux.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Oct 2013 08:34:17 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:


> @@ -1577,6 +1577,7 @@ static void event_remove(struct ftrace_event_call *call)
>  		if (file->event_call != call)
>  			continue;
>  		ftrace_event_enable_disable(file, 0);
> +		destroy_preds(file);
>  		/*
>  		 * The do_for_each_event_file() is
>  		 * a double loop. After finding the call for this
> @@ -1700,7 +1701,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>  {
>  	event_remove(call);
>  	trace_destroy_fields(call);
> -	destroy_preds(call);
> +	destroy_call_preds(call);

A small nit, but I don't believe we need this anymore.

First, what event that requires a call filter can be removed?

Second, if one could be removed, the previous call to "event_remove"
would remove the filter for us, as destroy_preds(file) calls
destroy_call_preds() if the USE_CALL_FILTER flag is set.

I'll keep it in for now, but may remove it later.

-- Steve


>  }
>  

