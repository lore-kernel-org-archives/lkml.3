Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3LILEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:04:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab3LILED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:04:03 -0500
Date: Mon, 9 Dec 2013 12:03:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 06/14] tools lib traceevent: Get rid of malloc_or_die()
 in find_event()
Message-ID: <20131209110350.GH1242@krava.brq.redhat.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
 <1386567251-22751-7-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386567251-22751-7-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 02:34:03PM +0900, Namhyung Kim wrote:
> Make it return -2 to distinguish malloc allocation failure.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/parse-filter.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index e9d17bfcdffd..06e5af9f8fc4 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -301,7 +301,10 @@ find_event(struct pevent *pevent, struct event_list **events,
>  		sys_name = NULL;
>  	}
>  
> -	reg = malloc_or_die(strlen(event_name) + 3);
> +	reg = malloc(strlen(event_name) + 3);
> +	if (reg == NULL)
> +		return -2;
> +

I guess we dont need error defines or enums when this is just
static function, but at least please add some comment (description)
of return values like in pevent_filter_match function

jirka
