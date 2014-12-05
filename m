Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaLEPbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaLEPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:31:09 -0500
Date: Fri, 5 Dec 2014 13:30:53 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 6/8] perf buildid cache: Fix -a segfault
Message-ID: <20141205153053.GB2285@redhat.com>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
 <1417460789-13874-7-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417460789-13874-7-git-send-email-jolsa@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 01, 2014 at 08:06:27PM +0100, Jiri Olsa escreveu:
> The kcore_filename is uninitialized and trash value could
> trigger build_id_cache__add_kcore function ending up with
> segfault.

Applied
 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/builtin-buildid-cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
> index 184955ec8a83..7a3504a1b494 100644
> --- a/tools/perf/builtin-buildid-cache.c
> +++ b/tools/perf/builtin-buildid-cache.c
> @@ -737,7 +737,7 @@ int cmd_buildid_cache(int argc, const char **argv,
>  		   *remove_name_list_str = NULL,
>  		   *missing_filename = NULL,
>  		   *update_name_list_str = NULL,
> -		   *kcore_filename;
> +		   *kcore_filename = NULL;
>  	char sbuf[STRERR_BUFSIZE];
>  
>  	struct perf_data_file file = {
> -- 
> 1.9.3
