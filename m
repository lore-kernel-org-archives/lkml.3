Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaAPDX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:23:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10262 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751325AbaAPDXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:23:54 -0500
Date: Wed, 15 Jan 2014 22:23:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 09/12] tools lib traceevent: Unregister handler when
 cfg80211 plugin unloaded
Message-ID: <20140115222349.3a0ad3de@gandalf.local.home>
In-Reply-To: <1389839478-5887-10-git-send-email-namhyung@kernel.org>
References: <1389839478-5887-1-git-send-email-namhyung@kernel.org>
	<1389839478-5887-10-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 11:31:15 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> The function handler should be unregistered when the plugin unloaded
> otherwise it'll try to access invalid memory.
> 
> Reviewed-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

You can add my Acked-by to patches 9-12 too.

-- Steve

> ---
>  tools/lib/traceevent/plugin_cfg80211.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
> index 57e98221db20..c066b25905f8 100644
> --- a/tools/lib/traceevent/plugin_cfg80211.c
> +++ b/tools/lib/traceevent/plugin_cfg80211.c
> @@ -22,3 +22,9 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
>  				       PEVENT_FUNC_ARG_VOID);
>  	return 0;
>  }
> +
> +void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
> +{
> +	pevent_unregister_print_function(pevent, process___le16_to_cpup,
> +					 "__le16_to_cpup");
> +}

