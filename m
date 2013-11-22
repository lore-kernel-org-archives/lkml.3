Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3KVP15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:27:57 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59020 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3KVP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:27:55 -0500
Subject: Re: [PATCH 17/22] perf tools: Add build and install plugins targets
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <1385031680-9014-18-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	 <1385031680-9014-18-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Nov 2013 00:27:48 +0900
Message-ID: <1385134068.1747.105.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> Adding 'plugins' target along with the libtraceevent.a,
> so plugins are built together with traceevent library.
> 
> Adding 'install-traceevent-plugins' Makefile install target,
> instructing perf to install plugins into:
>   $(HOME)/libexec/perf-core/traceevent/plugins
>     - if installed localy under $HOME
>   $(DESTDIR)/$(prefix)/$(perfexecdir)/traceevent/plugins
>     - if installed globally

[SNIP]
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -578,6 +578,7 @@ else
>  lib = lib
>  endif
>  libdir = $(prefix)/$(lib)
> +plugindir=$(perfexecdir)/traceevent/plugins

Hmm.. it puts traceevent plugins under the perf directory.  But I don't
think it's a good idea since libtraceevent can be used independently.

What about something like this?

  plugindir = $(perfexecdir)/../traceevent/plugins

Thanks,
Namhyung


