Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3KZLmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:42:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab3KZLmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:42:33 -0500
Date: Tue, 26 Nov 2013 12:42:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 2/5] perf diff: color the Delta column
Message-ID: <20131126114228.GF1267@krava.brq.redhat.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-3-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385274025-30282-3-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 11:50:22AM +0530, Ramkumar Ramachandra wrote:
> Color the numbers in the Delta column either green or red depending on
> whether the number is positive or negative.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 79e0448..84d5f2d 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -769,6 +769,33 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
>  	return ret;
>  }
>  
> +static int hpp__color_delta(struct perf_hpp_fmt *fmt,
> +			struct perf_hpp *hpp, struct hist_entry *he)
> +{
> +	struct diff_hpp_fmt *dfmt =
> +		container_of(fmt, struct diff_hpp_fmt, fmt);
> +	struct hist_entry *pair = get_pair_fmt(he, dfmt);
> +	double percent;
> +	char pfmt[20] = " ";
> +
> +	if (!pair)
> +		goto dummy_print;

same comment here ^^^ as for previous patch

jirka
