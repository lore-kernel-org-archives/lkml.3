Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3EaJHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:07:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50736 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab3EaJHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:07:07 -0400
Date: Fri, 31 May 2013 11:07:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 03/16] perf, persistent: Setting default buffer size to
 512k as in perf tools
Message-ID: <20130531090718.GD14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-4-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-4-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:23AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> The default buffer size used to setup event buffers with perf tools is
> 512k. Using the same buffer size for persistent events. This also
> avoids failed mmap calls due to different buffer sizes.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  kernel/events/persistent.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
> index 9075164..1e6c03a 100644
> --- a/kernel/events/persistent.c
> +++ b/kernel/events/persistent.c
> @@ -5,6 +5,9 @@
>  
>  #include "internal.h"
>  
> +/* 512 kiB: default perf tools memory size, see perf_evlist__mmap() */
> +#define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
> +
>  static DEFINE_PER_CPU(struct list_head, pers_events);
>  
>  static struct perf_event *
> @@ -151,7 +154,7 @@ int perf_add_persistent_event_by_id(int id)
>  	attr->type		= PERF_TYPE_TRACEPOINT;
>  	attr->size		= sizeof(*attr);
>  
> -	return perf_add_persistent_event(attr, 4);
> +	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);

This one too - the 4 pages I chose then was purely arbitrary for I had
no idea what size to pick. This clearly makes more sense.

Thanks.
