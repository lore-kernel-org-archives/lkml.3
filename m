Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaLYWJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:09:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbaLYWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:09:06 -0500
Date: Thu, 25 Dec 2014 23:08:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 04/37] perf tools: Add multi file interface to
 perf_data_file
Message-ID: <20141225220830.GA8719@krava>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:15:00PM +0900, Namhyung Kim wrote:

SNIP

>  #endif /* __PERF_DATA_H */
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index d5eab3f3323f..a5046d52e311 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -72,6 +72,49 @@ int mkdir_p(char *path, mode_t mode)
>  	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
>  }
>  
> +int rm_rf(char *path)
> +{
> +	DIR *dir;
> +	int ret = 0;
> +	struct dirent *d;
> +	char namebuf[PATH_MAX];
> +
> +	dir = opendir(path);
> +	if (dir == NULL)
> +		return 0;
> +
> +	while ((d = readdir(dir)) != NULL && !ret) {
> +		struct stat statbuf;
> +
> +		if (d->d_name[0] == '.')
> +			continue;

Could you check for '.' and for '..' to support '.*' removal?

I know tha we will probably not have any '.*' files in perf.data.dir,
but this function could be used later like for total cache clean ;-)

also please submit 'rm_rf' in separate patch

thanks,
jirka
