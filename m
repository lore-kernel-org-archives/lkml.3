Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaGIWta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbaGIWt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:49:29 -0400
Date: Thu, 10 Jul 2014 00:48:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/16] perf hists browser: Override ui_browser
 refresh_dimensions method
Message-ID: <20140709224849.GA23232@krava.redhat.com>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
 <1404846184-20075-5-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404846184-20075-5-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 04:02:52PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 

SNIP

> index ca63564d203a..ef7abf896f5a 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -56,11 +56,19 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
>  	return nr_entries + hb->nr_callchain_rows;
>  }
>  
> -static void hist_browser__refresh_dimensions(struct hist_browser *browser)
> +static void hist_browser__refresh_dimensions(struct ui_browser *browser)
>  {
> +	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
> +
>  	/* 3 == +/- toggle symbol before actual hist_entry rendering */
> -	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
> -			     sizeof("[k]"));
> +	browser->width = 3 + (hists__sort_list_width(hb->hists) + sizeof("[k]"));

why not remove this completely? it'll get overwritten in the
following ui_browser__refresh_dimensions call anyway..

> +	/*
> + 	 * FIXME: Just keeping existing behaviour, but this really should be
> + 	 *	  before updating browser->width, as it will invalidate the
> + 	 *	  calculation above. Fix this and the fallout in another
> + 	 *	  changeset.
> + 	 */

extra whitespace above

jirka
