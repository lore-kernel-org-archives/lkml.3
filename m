Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3AKN4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:56:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3AKN4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:56:24 -0500
Date: Fri, 11 Jan 2013 14:56:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH RESEND 3/5] perf tools: Add breakpoint address mask to
 the mem event parser
Message-ID: <20130111135608.GE2847@krava.brq.redhat.com>
References: <1357848659-4786-1-git-send-email-jacob.shin@amd.com>
 <1357848659-4786-4-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357848659-4786-4-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 02:10:57PM -0600, Jacob Shin wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Allow perf tool to pass in breakpoint address mask to match an address
> range, i.e.:
> 
>   $ perf stat -e mem:0x1000:w:0xf a.out
> 
> Will count writes to [0x1000 ~ 0x1010)
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  tools/perf/util/parse-events.c |    3 ++-
>  tools/perf/util/parse-events.h |    2 +-
>  tools/perf/util/parse-events.y |   14 ++++++++++++--
>  3 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 2d8d53be..2679e48 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -466,12 +466,13 @@ do {					\
>  }
>  
>  int parse_events_add_breakpoint(struct list_head **list, int *idx,
> -				void *ptr, char *type)
> +				void *ptr, char *type, void *msk)
>  {
>  	struct perf_event_attr attr;
>  
>  	memset(&attr, 0, sizeof(attr));
>  	attr.bp_addr = (unsigned long) ptr;
> +	attr.bp_addr_mask = (unsigned long) msk;

looks like the 'msk' argument could be unsigned long directly

jirka
