Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaAHPKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:10:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbaAHPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:10:50 -0500
Date: Wed, 8 Jan 2014 13:10:38 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 2/8] perf tools: Make the print_pmu_events funtion to
 return unsigned int.
Message-ID: <20140108151038.GA2626@infradead.org>
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com>
 <52353637cf8005cef5f3eaa605121426ef49f557.1388416837.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52353637cf8005cef5f3eaa605121426ef49f557.1388416837.git.yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 30, 2013 at 10:26:37AM -0500, Dongsheng Yang escreveu:
> Sometimes we need to know how many events have been printed in print_pmu_events.

"Sometimes" is too vague, of course it should be needed, otherwise why
bother with the patch? It would be better if you provided an example of
_where_ it will be used, like when printing that newline.

Anyway, reading the other patches,

- Arnaldo
 
> This patch make this function to return the number of events we have printed.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tools/perf/util/pmu.c | 12 +++++++-----
>  tools/perf/util/pmu.h |  2 +-
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 0934d64..331dc2c 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -711,12 +711,12 @@ static int cmp_string(const void *a, const void *b)
>  	return strcmp(*as, *bs);
>  }
>  
> -void print_pmu_events(const char *event_glob, bool name_only)
> +unsigned int print_pmu_events(const char *event_glob, bool name_only)
>  {
>  	struct perf_pmu *pmu;
>  	struct perf_pmu_alias *alias;
>  	char buf[1024];
> -	int printed = 0;
> +	unsigned int count = 0;
>  	int len, j;
>  	char **aliases;
>  
> @@ -727,7 +727,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  			len++;
>  	aliases = malloc(sizeof(char *) * len);
>  	if (!aliases)
> -		return;
> +		return count;
>  	pmu = NULL;
>  	j = 0;
>  	while ((pmu = perf_pmu__scan(pmu)) != NULL)
> @@ -752,15 +752,17 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  	for (j = 0; j < len; j++) {
>  		if (name_only) {
>  			printf("%s ", aliases[j]);
> +			count++;
>  			continue;
>  		}
>  		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
>  		zfree(&aliases[j]);
> -		printed++;
> +		count++;
>  	}
> -	if (printed)
> +	if (count)
>  		printf("\n");
>  	free(aliases);
> +	return count;
>  }
>  
>  bool pmu_have_event(const char *pname, const char *name)
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index 9183380..2987fe2 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -42,7 +42,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
>  
>  struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
>  
> -void print_pmu_events(const char *event_glob, bool name_only);
> +unsigned int print_pmu_events(const char *event_glob, bool name_only);
>  bool pmu_have_event(const char *pname, const char *name);
>  
>  int perf_pmu__test(void);
> -- 
> 1.8.2.1
