Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab3KUL6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:58:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64831 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753177Ab3KUL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:58:23 -0500
Date: Thu, 21 Nov 2013 06:58:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 01/22] tools lib traceevent: Add plugin support
Message-ID: <20131121065820.7e9855c5@gandalf.local.home>
In-Reply-To: <1385031680-9014-2-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	<1385031680-9014-2-git-send-email-jolsa@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013 12:00:59 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> Backporting plugin support for traceevent lib.
> 
> Backported from Steven Rostedt's trace-cmd repo (HEAD 0f2c2fb):
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> 
> It's now possible to use following interface to load plugins
> (shared objects) to enahnce pevent object functionality.
> 
> The plugin interface/hooks are as follows:
> (taken from event-parse.h comments)
> 
> - 'pevent_plugin_loader' (required)
>     The function name to initialized the plugin.
> 
>     int pevent_plugin_loader(struct pevent *pevent)
> 
> - 'pevent_plugin_unloader' (optional)
>     The function called just before unloading
> 
>     int pevent_plugin_unloader(void)
> 
> - 'pevent_plugin_options'  (optional)
>     Plugin options that can be set before loading
> 
>     struct plugin_option pevent_plugin_options[] = {
>        {
>                .name = "option-name",
>                .plugin_alias = "overide-file-name", (optional)
>                .description = "description of option to show users",
>        },
>        {
>                .name = NULL,
>        },
>     };
> 
>     Array must end with .name = NULL;
> 
>     The plugin_alias (below) can be used to give a shorter
>     name to access the vairable. Useful if a plugin handles
>     more than one event.
> 
>     NOTE options support is not backported yet.
> 
> - 'pevent_plugin_alias' (optional)
>     The name to use for finding options (uses filename if not defined)
> 
> New traceevent functions are added to search and load
> available plugins:
> 
>   struct plugin_list*
>   traceevent_load_plugins(struct pevent *pevent)
>     - loads plusing for 'struct pevent' object and returns
>       loaded plugins list
> 
>   void traceevent_unload_plugins(struct plugin_list *plugin_list);
>     - unload plugin list
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

As I authored the original code, you can add my:

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: David Ahern <dsahern@gmail.com>
> ---
>  tools/lib/traceevent/Makefile       |   6 +-
>  tools/lib/traceevent/event-parse.h  |   5 +
>  tools/lib/traceevent/event-plugin.c | 202 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 212 insertions(+), 1 deletion(-)
>  create mode 100644 tools/lib/traceevent/event-plugin.c
> 
