Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaFDWVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:21:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:21394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaFDWUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,975,1392192000"; 
   d="scan'208";a="542596258"
Date: Wed, 4 Jun 2014 15:20:47 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: parse-events.c:  Cleaning up missing
 null-terminate after strncpy call
Message-ID: <20140604222047.GA16855@tassilo.jf.intel.com>
References: <1401918378-3842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401918378-3842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 11:46:18PM +0200, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 
> This was partly found using a static code analysis program called cppcheck.

Should just stop using strncpy. strncpy semantics don't make any
sense at all, and it's inefficient. I would just snprintf here

-Andi

> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  tools/perf/util/parse-events.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 1e15df1..fad2976 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1216,8 +1216,10 @@ static void print_symbol_events(const char *event_glob, unsigned type,
>  
>  		if (strlen(syms->alias))
>  			snprintf(name, MAX_NAME_LEN, "%s OR %s", syms->symbol, syms->alias);
> -		else
> +		else {
>  			strncpy(name, syms->symbol, MAX_NAME_LEN);
> +			name[sizeof(name) - 1] = '\0';
> +		}
>  
>  		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
>  
> -- 
> 1.7.10.4
> 

-- 
ak@linux.intel.com -- Speaking for myself only
