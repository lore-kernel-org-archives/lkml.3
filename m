Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaAOUgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:36:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18731 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751589AbaAOUgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:36:02 -0500
Date: Wed, 15 Jan 2014 15:35:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 15/17] tools lib traceevent: Unregister handler when
 jbd2 plugin unloaded
Message-ID: <20140115153558.7d11cb78@gandalf.local.home>
In-Reply-To: <1389750340-15965-16-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-16-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:38 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> The function handlers should be unregistered when the plugin unloaded
> otherwise they'll try to access invalid memory.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/plugin_jbd2.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
> index 2f93f81f0bac..88fe6fe872d5 100644
> --- a/tools/lib/traceevent/plugin_jbd2.c
> +++ b/tools/lib/traceevent/plugin_jbd2.c
> @@ -66,3 +66,14 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
>  				       PEVENT_FUNC_ARG_VOID);
>  	return 0;
>  }
> +
> +void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
> +{
> +	pevent_unregister_print_function(pevent,
> +					 process_jbd2_dev_to_name,
> +					 "jbd2_dev_to_name");
> +
> +	pevent_unregister_print_function(pevent,
> +					 process_jiffies_to_msecs,
> +					 "jiffies_to_msecs");
> +}

Same here. I don't know about others, but I think it looks a bit nicer
if we move the function up to the first line.

-- Steve

