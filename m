Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaBTKtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:49:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbaBTKtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:49:31 -0500
Date: Thu, 20 Feb 2014 11:49:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 5/8] perf diff: Add --percentage option
Message-ID: <20140220104917.GD11018@krava.brq.redhat.com>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
 <1392000446-14744-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392000446-14744-6-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:47:22AM +0900, Namhyung Kim wrote:
> The --percentage option is for controlling overhead percentage
> displayed.  It can only receive either of "relative" or "absolute" and
> affects -c delta output only.
> 
> For more information, please see previous commit same thing done to
> "perf report".
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Documentation/perf-diff.txt | 21 +++++++++++++---
>  tools/perf/builtin-diff.c              | 46 +++++++++++++++++++++++++++++-----
>  2 files changed, 58 insertions(+), 9 deletions(-)

SNIP

> @@ -259,11 +263,18 @@ static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
>  static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
>  			 char *buf, size_t size)
>  {
> +	u64 he_total = he->hists->stats.total_period;
> +	u64 pair_total = pair->hists->stats.total_period;
> +
> +	if (symbol_conf.filter_relative) {
> +		he_total = he->hists->stats.total_filtered_period;
> +		pair_total = pair->hists->stats.total_filtered_period;
> +	}

and another ;-)

jirka
