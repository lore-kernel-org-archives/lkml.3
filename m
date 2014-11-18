Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaKRIZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaKRIZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:25:11 -0500
Date: Tue, 18 Nov 2014 09:24:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
 add_callchain_ip
Message-ID: <20141118082454.GB27645@krava.brq.redhat.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415972652-17310-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 08:44:11AM -0500, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> Move the cpumode resolve code to add_callchain_ip function.
> No change in behavior.
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  tools/perf/util/machine.c | 62 ++++++++++++++++++++++-------------------------
>  1 file changed, 29 insertions(+), 33 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index d97309c..dd8496a 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1384,11 +1384,35 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
>  static int add_callchain_ip(struct thread *thread,
>  			    struct symbol **parent,
>  			    struct addr_location *root_al,
> -			    int cpumode,
> +			    u8 cpumode,

Andi's patch got in:
b3340a5 perf callchain: Support handling complete branch stacks as histograms

and it uses the cpumode check for -1, so it needs to stay int, otherwise
there's a compilation failure:

  CC       util/machine.o
util/machine.c: In function ‘add_callchain_ip’:
util/machine.c:1419:14: error: comparison is always false due to limited range of data type [-Werror=type-limits]
  if (cpumode == -1)
              ^


jirka
