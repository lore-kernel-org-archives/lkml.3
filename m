Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaEWHGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbaEWHGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:06:01 -0400
Date: Fri, 23 May 2014 09:05:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: session.c:  Cleaning up inconsistent
 NULL checks
Message-ID: <20140523070534.GB1074@krava>
References: <1400795916-12613-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400795916-12613-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:58:36PM +0200, Rickard Strandqvist wrote:
> Cleaning up inconsistent NULL checks.
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  tools/perf/util/session.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 55960f2..8defd80 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1625,13 +1625,15 @@ out_delete_map:
>  void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
>  				bool full)
>  {
> -	int fd = perf_data_file__fd(session->file);
> +	int fd;
>  	struct stat st;
>  	int ret;
>  
>  	if (session == NULL || fp == NULL)
>  		return;
>  
> +	fd = perf_data_file__fd(session->file);
> +
>  	ret = fstat(fd, &st);
>  	if (ret == -1)
>  		return;
> -- 
> 1.7.10.4
> 
hi,
I merged same patch just a week ago or so ;-)

perf session: Fix possible null pointer dereference in session.c
commit c5765ece8a050836c6255e1276fc8e0e867078da
Author: Masanari Iida <standby24x7@gmail.com>
Date:   Thu May 15 02:13:38 2014 +0900


thanks,
jirka
