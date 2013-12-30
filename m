Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3L3HtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:49:09 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51345 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab3L3HtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:49:07 -0500
MIME-Version: 1.0
In-Reply-To: <1388388861-7931-5-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-1-git-send-email-artagnon@gmail.com> <1388388861-7931-5-git-send-email-artagnon@gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 30 Dec 2013 13:18:26 +0530
Message-ID: <CALkWK0mfVorU-CrebfaCcObAyddoq8+FxXAu26viWXWbz4OZxg@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] perf diff: color the Weighted Diff column
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index c07cd3c..9c69620 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -777,6 +777,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>                 container_of(fmt, struct diff_hpp_fmt, fmt);
>         struct hist_entry *pair = get_pair_fmt(he, dfmt);
>         double diff;
> +       s64 wdiff;
>         char pfmt[20] = " ";
>
>         if (!pair)
> @@ -805,6 +806,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
>                 scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
>                 return value_color_snprintf(hpp->buf, hpp->size,
>                                         pfmt, diff);
> +       case COMPUTE_WEIGHTED_DIFF:
> +               if (he->dummy)
> +                       goto dummy_print;
> +               if (pair->diff.computed)
> +                       wdiff = pair->diff.wdiff;
> +               else
> +                       wdiff = compute_wdiff(he, pair);
> +
> +               scnprintf(pfmt, 20, "%%14ld", dfmt->header_width);
> +               return value_color_snprintf(hpp->buf, hpp->size,
> +                                       pfmt, wdiff);

Oops, I sent this out too fast. value_color_snprintf() accepts a
double, but wdiff is an s64. As a result, the wdiff column is
populated with zeros.

Will resend.
