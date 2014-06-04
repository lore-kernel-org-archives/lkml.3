Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaFDBtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:49:42 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62274 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaFDBtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:49:40 -0400
Message-ID: <538E7B2F.2000100@gmail.com>
Date: Tue, 03 Jun 2014 19:49:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
CC: Jiri Olsa <jolsa@redhat.com>, mingo@kernel.org, sam@ravnborg.org,
        mmarek@suse.cz, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kbuild@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/32] perf tools: Kbuild source related fixies
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com> <1401833185-10347-4-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1401833185-10347-4-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/14, 4:05 PM, Alexis Berlemont wrote:
> From: Jiri Olsa <jolsa@redhat.com>
>
> Fixing several sources config dependencies to allow
> separate config builds.
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
>   tools/perf/builtin-lock.c        |  4 +++-
>   tools/perf/builtin-sched.c       |  2 ++
>   tools/perf/perf.c                |  6 ++++++
>   tools/perf/perf.h                |  2 ++
>   tools/perf/ui/browsers/scripts.c |  4 ++++
>   tools/perf/ui/setup.c            | 10 +++++++++-
>   6 files changed, 26 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
> index c852c7a..b255c20 100644
> --- a/tools/perf/builtin-lock.c
> +++ b/tools/perf/builtin-lock.c
> @@ -992,9 +992,11 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
>   				usage_with_options(report_usage, report_options);
>   		}
>   		rc = __cmd_report(false);
> +#ifdef CONFIG_BULTIN_SCRIPT
>   	} else if (!strcmp(argv[0], "script")) {
>   		/* Aliased to 'perf script' */
> -		return cmd_script(argc, argv, prefix);
> +		rc = cmd_script(argc, argv, prefix);
> +#endif
>   	} else if (!strcmp(argv[0], "info")) {
>   		if (argc) {
>   			argc = parse_options(argc, argv,

Since you are not adding builtin-cmds.h as an included file this change 
takes away functionality. Each patch should ensure that existing options 
continue to work after the change.

ditto for all of the other changes to other files.

David
