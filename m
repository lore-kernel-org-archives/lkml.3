Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3JYO5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:57:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab3JYO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:57:11 -0400
Date: Fri, 25 Oct 2013 16:56:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, zheng.z.yan@intel.com,
        bp@alien8.de
Subject: Re: [PATCH v3 1/4] perf: add active_entry list head to struct
 perf_event
Message-ID: <20131025145625.GB1196@krava.brq.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
 <1382533085-7166-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382533085-7166-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 02:58:02PM +0200, Stephane Eranian wrote:
> This patch adds a new fields to the struct perf_event.
> It is intended to be used to chain events which are
> active (enabled). It helps in the hardware layer
> for PMU which do not have actual counter restrictions, i.e.,
> free running read-only counters. Active events are chained
> as opposed to being tracked via the counter they use.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/linux/perf_event.h |    1 +
>  kernel/events/core.c       |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 2e069d1..a376384 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -435,6 +435,7 @@ struct perf_event {
>  	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
>  	int				cgrp_defer_enabled;
>  #endif
> +	struct list_head		active_entry;

Could this be in union with 'hlist_entry' ? It looks
as 'same purpose' and 'mutualy exclusive stuff.

jirka
