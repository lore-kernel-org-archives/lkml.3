Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbaDVOwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:52:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676AbaDVOwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:52:17 -0400
Date: Tue, 22 Apr 2014 16:52:03 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/9] perf hists: Introduce hists__add_nr_events()
Message-ID: <20140422145203.GH1104@krava.brq.redhat.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <1398156591-11001-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:49:44PM +0900, Namhyung Kim wrote:
> The hists__add_nr_events() is a helper function intended to be ran
> inside of hists__inc_nr_entries().  However this requires other
> changes that handled in the next patch.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/hist.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 5a892477aa50..1c77714f668d 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -317,6 +317,27 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
>  	return he;
>  }
>  
> +static void __events_stats__add(struct events_stats *stats, u32 type, u32 val)
> +{
> +	stats->nr_events[0] += val;
> +	stats->nr_events[type] += val;
> +}
> +
> +void events_stats__inc(struct events_stats *stats, u32 type)
> +{
> +	__events_stats__add(stats, type, 1);
> +}
> +
> +void hists__inc_nr_events(struct hists *hists, u32 type)
> +{
> +	__events_stats__add(&hists->stats, type, 1);
> +}
> +
> +static void hists__add_nr_events(struct hists *hists, u32 type, u32 val)
> +{
> +	__events_stats__add(&hists->stats, type, val);
> +}

adding static function with no usage breaks build..
we dont want that, eventhough it's fixed in the next commit

thanks,
jirka
