Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaDMSJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 14:09:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066AbaDMSJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:09:24 -0400
Date: Sun, 13 Apr 2014 20:08:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, tools: Support spark lines in perf stat
Message-ID: <20140413180837.GA25898@krava.redhat.com>
References: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
 <1395768699-16060-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395768699-16060-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:31:39AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 

SNIP

> index 65a151e..6bf7b6c 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -1176,6 +1176,9 @@ static void print_aggr(char *prefix)
>  				if (run != ena)
>  					fprintf(output, "  (%.2f%%)",
>  						100.0 * run / ena);
> +
> +				fputc(' ', output);
> +				print_stat_spark(output, counter->priv);

I dont think we want it in csv output

[jolsa@krava perf]$ ./perf stat -r 20 -x , true
0.285896,,task-clock,2.39% █▃▃▂▂▁▁▁..
0,,context-switches,0.00% 
0,,cpu-migrations,100.00% 
91,,page-faults,0.08% █▁██████..
165335,,cycles,30.69% █▇▇▁▇▁▁▁..


jirka
