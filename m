Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970AbaDJJJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934837AbaDJJJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:09:30 -0400
Date: Thu, 10 Apr 2014 11:09:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf tools: Fix double free in perf test 21
 (code-reading.c)
Message-ID: <20140410090925.GD1141@krava.brq.redhat.com>
References: <20140410082648.GB1141@krava.brq.redhat.com>
 <53465E3E.8070201@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53465E3E.8070201@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 12:02:54PM +0300, Adrian Hunter wrote:
> perf_evlist__delete() deletes attached cpu and thread maps
> but the test is still using them, so remove them from the
> evlist before deleting it.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/tests/code-reading.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
> index 653a8fe..bfb1869 100644
> --- a/tools/perf/tests/code-reading.c
> +++ b/tools/perf/tests/code-reading.c
> @@ -504,6 +504,7 @@ static int do_test_code_reading(bool try_kcore)
>  		if (ret < 0) {
>  			if (!excl_kernel) {
>  				excl_kernel = true;
> +				perf_evlist__set_maps(evlist, NULL, NULL);
>  				perf_evlist__delete(evlist);
>  				evlist = NULL;
>  				continue;
> -- 
> 1.8.3.2
> 
> 

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
