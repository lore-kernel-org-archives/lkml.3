Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3LCQQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:16:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11119 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753815Ab3LCQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:16:04 -0500
Date: Tue, 3 Dec 2013 11:16:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 22/28] tools lib traceevent: Remove malloc_or_die from
 event-plugin.c
Message-ID: <20131203111601.540ed5f7@gandalf.local.home>
In-Reply-To: <1386076182-14484-23-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-1-git-send-email-jolsa@redhat.com>
	<1386076182-14484-23-git-send-email-jolsa@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Dec 2013 14:09:36 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> Removing malloc_or_die calls from event-plugin.c,
> replacing them with standard malloc and error path.
> 
> Suggested-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/lib/traceevent/event-plugin.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> index d272d87..125f567 100644
> --- a/tools/lib/traceevent/event-plugin.c
> +++ b/tools/lib/traceevent/event-plugin.c
> @@ -47,7 +47,11 @@ load_plugin(struct pevent *pevent, const char *path,
>  	char *plugin;
>  	void *handle;
>  
> -	plugin = malloc_or_die(strlen(path) + strlen(file) + 2);
> +	plugin = malloc(strlen(path) + strlen(file) + 2);
> +	if (!plugin) {
> +		warning("could not allocate plugin memory\n");
> +		return;

This should be changed to return an error code. Yes it will require
other places to change for that update as well.

-- Steve

> +	}
>  
>  	strcpy(plugin, path);
>  	strcat(plugin, "/");
