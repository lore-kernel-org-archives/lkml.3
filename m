Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbaFDG6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:58:13 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61306 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbaFDG6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:58:12 -0400
Message-ID: <1401865089.14072.9.camel@x220>
Subject: Re: [PATCH 02/32] perf tools: Kbuild builtin source related fixies
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kbuild@vger.kernel.org, Stephane Eranian <eranian@google.com>
Date: Wed, 04 Jun 2014 08:58:09 +0200
In-Reply-To: <1401833185-10347-3-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
	 <1401833185-10347-3-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2014 06:58:10.0216 (UTC) FILETIME=[587F6280:01CF7FC2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 00:05 +0200, Alexis Berlemont wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> Adding CONFIG_BUILTIN_* defines to govern builtin commands.
> This will be usefull for kbuild process switch.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-cmds.h           | 27 ++++++++++++++++++++++
>  tools/perf/builtin-help.c           |  1 +
>  tools/perf/perf.c                   | 45 +++++++++++++++++++++++++++++++++++--
>  tools/perf/util/generate-cmdlist.sh | 10 +++++++++
>  4 files changed, 81 insertions(+), 2 deletions(-)
>  create mode 100644 tools/perf/builtin-cmds.h
> 
> diff --git a/tools/perf/builtin-cmds.h b/tools/perf/builtin-cmds.h
> new file mode 100644
> index 0000000..fec342a
> --- /dev/null
> +++ b/tools/perf/builtin-cmds.h
> @@ -0,0 +1,27 @@
> +#ifndef BUILTIN_CMDS_H
> +#define BUILTIN_CMDS_H
> +
> +#define CONFIG_BUILTIN_REPORT 1
> +#define CONFIG_BUILTIN_SCRIPT 1
> +#define CONFIG_BUILTIN_BENCH 1
> +#define CONFIG_BUILTIN_SCHED 1
> +#define CONFIG_BUILTIN_TRACE 1
> +#define CONFIG_BUILTIN_TOP 1
> +#define CONFIG_BUILTIN_RECORD 1
> +#define CONFIG_BUILTIN_BUILDID_LIST 1
> +#define CONFIG_BUILTIN_INJECT 1
> +#define CONFIG_BUILTIN_LOCK 1
> +#define CONFIG_BUILTIN_KVM 1
> +#define CONFIG_BUILTIN_BUILDID_CACHE 1
> +#define CONFIG_BUILTIN_EVLIST 1
> +#define CONFIG_BUILTIN_KMEM 1
> +#define CONFIG_BUILTIN_STAT 1
> +#define CONFIG_BUILTIN_DIFF 1
> +#define CONFIG_BUILTIN_ANNOTATE 1
> +#define CONFIG_BUILTIN_TIMECHART 1
> +#define CONFIG_BUILTIN_LIST 1
> +#define CONFIG_BUILTIN_HELP 1
> +#define CONFIG_BUILTIN_PROBE 1
> +#define CONFIG_BUILTIN_MEM 1
> +
> +#endif /* BUILTIN_CMDS_H */

Pet peeve: #defines with a CONFIG_ prefix. Is that prefix needed here or
would another prefix also do? Or can these macros perhaps be added
through a Kconfig file (eg, as "config BUILTIN_REPORT" etc.). Or will
that happen at the "kbuild process switch"?


Paul Bolle

