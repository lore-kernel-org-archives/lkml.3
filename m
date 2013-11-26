Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3KZLc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:32:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab3KZLcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:32:53 -0500
Date: Tue, 26 Nov 2013 12:32:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2 1/5] perf diff: don't compute Delta if he->dummy
Message-ID: <20131126113250.GE1267@krava.brq.redhat.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-2-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385274025-30282-2-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 11:50:21AM +0530, Ramkumar Ramachandra wrote:
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/builtin-diff.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 3b67ea2..79e0448 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -792,6 +792,9 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
>  
>  	switch (idx) {
>  	case PERF_HPP_DIFF__DELTA:
> +		if (he->dummy)
> +			break;
> +

the reason I disabled the computation for dummy pairs was
that the number (ratio and weighted diff) would not make much
sense (to me) without the real pair

but within the dummy delta column we actually see the compared
file % overheader which is helpfull, even if there's no real pair
in the baseline

jirka
