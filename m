Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab3JTUnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 16:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab3JTUnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 16:43:32 -0400
Date: Sun, 20 Oct 2013 22:43:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/19] perf record: Improve write_output error message
Message-ID: <20131020204316.GB12044@krava>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-4-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382099356-4918-4-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 03:29:00PM +0300, Adrian Hunter wrote:
> Improve the error message from write_output() to say
> what failed to write and give the error number.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/builtin-record.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 92ca541..d269dfa 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -88,7 +88,7 @@ static int write_output(struct perf_record *rec, void *buf, size_t size)
>  		int ret = write(rec->output, buf, size);
>  
>  		if (ret < 0) {
> -			pr_err("failed to write\n");
> +			pr_err("failed to write perf data, error: %m\n");

is this some kind of format magic? ;-) you wanted
to print out 'ret' value, right?

jirka
