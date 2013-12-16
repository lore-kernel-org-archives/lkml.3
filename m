Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3LPNUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:20:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab3LPNUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:20:00 -0500
Date: Mon, 16 Dec 2013 11:19:54 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf list: fix --raw-dump
Message-ID: <20131216131954.GB2368@infradead.org>
References: <1386756980-23121-1-git-send-email-artagnon@gmail.com>
 <52A8D2DA.7050409@gmail.com>
 <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 12, 2013 at 01:04:04PM +0530, Ramkumar Ramachandra escreveu:
> David Ahern wrote:
> > Why not make raw_dump a proper argument?
> 
> Sure, that'd work too. I was thinking of a minimal way to fix the
> problem myself.

So is the patch below the one to apply? When these things happen, it
helps if you resubmit with a v2 in the subject line and then an explicit
Ack is provided, be it from, in this case, David, or Ramkumar could just
add it since David provided it in free form, ok?

- Arnaldo
 
> > diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> > index 011195e38f21..b553d0c4ca82 100644
> > --- a/tools/perf/builtin-list.c
> > +++ b/tools/perf/builtin-list.c
> > @@ -36,6 +38,10 @@ int cmd_list(int argc, const char
> >              print_events(NULL, false);
> >              return 0;
> >        }
> > +      if (raw_dump) {
> > +            print_events(NULL, true);
> > +            return 0;
> > +      }
> 
> This won't work because you've put it right below the `if (argc ==
> 0)`, which executes print_events(). You could move it up and get it to
> work.

> From 7198a494cfef43395e8683ac3a0576277b8d1d80 Mon Sep 17 00:00:00 2001
> From: David Ahern <dsahern@gmail.com>
> Date: Wed, 11 Dec 2013 14:00:20 -0700
> Subject: [PATCH] perf list: Fix raw-dump arg
> 
> Ramkumar reported that perf list --raw-dump was broken by 44d742e.
> Fix by making raw-dump a proper argument.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Ramkumar Ramachandra <artagnon@gmail.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-list.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
> index 011195e..2629c24 100644
> --- a/tools/perf/builtin-list.c
> +++ b/tools/perf/builtin-list.c
> @@ -19,7 +19,9 @@
>  int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	int i;
> +	bool raw_dump = false;
>  	const struct option list_options[] = {
> +		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
>  		OPT_END()
>  	};
>  	const char * const list_usage[] = {
> @@ -32,6 +34,10 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	setup_pager();
>  
> +	if (raw_dump) {
> +		print_events(NULL, true);
> +		return 0;
> +	}
>  	if (argc == 0) {
>  		print_events(NULL, false);
>  		return 0;
> @@ -53,8 +59,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
>  			print_hwcache_events(NULL, false);
>  		else if (strcmp(argv[i], "pmu") == 0)
>  			print_pmu_events(NULL, false);
> -		else if (strcmp(argv[i], "--raw-dump") == 0)
> -			print_events(NULL, true);
>  		else {
>  			char *sep = strchr(argv[i], ':'), *s;
>  			int sep_idx;
> -- 
> 1.8.5.1.113.g8cb5bef.dirty
> 

