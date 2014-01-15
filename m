Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaAOUga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:36:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52300 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751613AbaAOUg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:36:28 -0500
Date: Wed, 15 Jan 2014 15:36:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 16/17] tools lib traceevent: Unregister handler when
 scsi plugin unloaded
Message-ID: <20140115153626.79977c6b@gandalf.local.home>
In-Reply-To: <1389750340-15965-17-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-17-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:39 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> The function handler should be unregistered when the plugin unloaded
> otherwise it'll try to access invalid memory.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/plugin_scsi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
> index 6fb8e3e3fcad..64d688534518 100644
> --- a/tools/lib/traceevent/plugin_scsi.c
> +++ b/tools/lib/traceevent/plugin_scsi.c
> @@ -421,3 +421,10 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
>  				       PEVENT_FUNC_ARG_VOID);
>  	return 0;
>  }
> +
> +void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
> +{
> +	pevent_unregister_print_function(pevent,
> +					 process_scsi_trace_parse_cdb,
> +					 "scsi_trace_parse_cdb");
> +}

Seems we have a trend ;-)

Same for patch 17.

-- Steve

