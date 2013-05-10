Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3EJMRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3EJMRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:17:10 -0400
Date: Fri, 10 May 2013 14:14:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 04/13] perf session: export a few functions for event
 processing
Message-ID: <20130510121459.GH1040@krava.brq.redhat.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
 <1368073909-8825-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368073909-8825-5-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:31:40PM -0600, David Ahern wrote:
> Allows kvm live mode to reuse the event processing and ordered samples
> processing used by the perf-report path.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  tools/perf/util/session.c |   14 +++++++-------
>  tools/perf/util/session.h |    9 +++++++++
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 7e2c4c7..355b01f 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -248,7 +248,7 @@ static int process_finished_round(struct perf_tool *tool,
>  				  union perf_event *event,
>  				  struct perf_session *session);
>  
> -static void perf_tool__fill_defaults(struct perf_tool *tool)
> +void perf_tool__fill_defaults(struct perf_tool *tool)
>  {
>  	if (tool->sample == NULL)
>  		tool->sample = process_event_sample_stub;
> @@ -494,8 +494,8 @@ static int perf_session_deliver_event(struct perf_session *session,
>  				      struct perf_tool *tool,
>  				      u64 file_offset);
>  
> -static int flush_sample_queue(struct perf_session *s,
> -			       struct perf_tool *tool)
> +int flush_sample_queue(struct perf_session *s,
> +		       struct perf_tool *tool)

hm, can't see flush_sample_queue being used globaly

jirka
