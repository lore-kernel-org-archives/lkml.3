Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaBRM5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:57:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbaBRM44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:56:56 -0500
Date: Tue, 18 Feb 2014 13:56:44 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 05/21] perf, session: Change header.misc dump from
 decimal to hex
Message-ID: <20140218125644.GG4343@krava.brq.redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-6-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053356-23024-6-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:29:00PM -0500, Don Zickus wrote:
> When printing the raw dump of a data file, the header.misc is
> printed as a decimal.  Unfortunately, that field is a bit mask, so
> it is hard to interpret as a decimal.
> 
> Print in hex, so the user can easily see what bits are set and more
> importantly what type of info it is conveying.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/session.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 0b39a48..d1ad10f 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -793,7 +793,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
>  	if (!dump_trace)
>  		return;
>  
> -	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
> +	printf("(IP, %x): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
>  	       event->header.misc, sample->pid, sample->tid, sample->ip,
>  	       sample->period, sample->addr);

nit, maybe use '0x%x' ? hum, but probably nobody is actually parsing this..

jirka
