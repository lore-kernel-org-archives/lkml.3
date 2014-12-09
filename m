Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbaLIMbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:31:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:60437 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbaLIMbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:31:15 -0500
Date: Tue, 9 Dec 2014 09:31:11 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] calloc/xcalloc: fix argument order
Message-ID: <20141209123111.GB4189@kernel.org>
References: <1417866043-1877-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417866043-1877-1-git-send-email-arjun024@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 06, 2014 at 05:10:43PM +0530, Arjun Sreedharan escreveu:
> calloc() and xcalloc() takes @nmemb first and then @size.
> fix all w/ pattern "calloc\s*(\s*sizeof".

Thanks, applied.
 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  scripts/kconfig/mconf.c    | 4 ++--
>  tools/perf/ui/hist.c       | 4 ++--
>  tools/thermal/tmon/sysfs.c | 6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 14cea74..4dd3755 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -330,10 +330,10 @@ static void set_subtitle(void)
>  	list_for_each_entry(sp, &trail, entries) {
>  		if (sp->text) {
>  			if (pos) {
> -				pos->next = xcalloc(sizeof(*pos), 1);
> +				pos->next = xcalloc(1, sizeof(*pos));
>  				pos = pos->next;
>  			} else {
> -				subtitles = pos = xcalloc(sizeof(*pos), 1);
> +				subtitles = pos = xcalloc(1, sizeof(*pos));
>  			}
>  			pos->text = sp->text;
>  		}
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index 2af1837..dc0d095 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -162,8 +162,8 @@ static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
>  		return ret;
>  
>  	nr_members = evsel->nr_members;
> -	fields_a = calloc(sizeof(*fields_a), nr_members);
> -	fields_b = calloc(sizeof(*fields_b), nr_members);
> +	fields_a = calloc(nr_members, sizeof(*fields_a));
> +	fields_b = calloc(nr_members, sizeof(*fields_b));
>  
>  	if (!fields_a || !fields_b)
>  		goto out;
> diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
> index dfe4548..1c12536 100644
> --- a/tools/thermal/tmon/sysfs.c
> +++ b/tools/thermal/tmon/sysfs.c
> @@ -446,7 +446,7 @@ int probe_thermal_sysfs(void)
>  		return -1;
>  	}
>  
> -	ptdata.tzi = calloc(sizeof(struct tz_info), ptdata.max_tz_instance+1);
> +	ptdata.tzi = calloc(ptdata.max_tz_instance+1, sizeof(struct tz_info));
>  	if (!ptdata.tzi) {
>  		fprintf(stderr, "Err: allocate tz_info\n");
>  		return -1;
> @@ -454,8 +454,8 @@ int probe_thermal_sysfs(void)
>  
>  	/* we still show thermal zone information if there is no cdev */
>  	if (ptdata.nr_cooling_dev) {
> -		ptdata.cdi = calloc(sizeof(struct cdev_info),
> -				ptdata.max_cdev_instance + 1);
> +		ptdata.cdi = calloc(ptdata.max_cdev_instance + 1,
> +				sizeof(struct cdev_info));
>  		if (!ptdata.cdi) {
>  			free(ptdata.tzi);
>  			fprintf(stderr, "Err: allocate cdev_info\n");
> -- 
> 1.8.1.msysgit.1
