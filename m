Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaGIWT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbaGIWT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:19:56 -0400
Date: Thu, 10 Jul 2014 00:19:33 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/9] perf, tools: Automatically look for event file name
 for cpu v3
Message-ID: <20140709221933.GF20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:15:59PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

> new file mode 100644
> index 0000000..e1cd76c
> --- /dev/null
> +++ b/tools/perf/arch/x86/util/cpustr.c
> @@ -0,0 +1,34 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include "../../util/jevents.h"
> +
> +char *get_cpu_str(void)
> +{
> +	char *line = NULL;
> +	size_t llen = 0;
> +	int found = 0, n;
> +	char vendor[30];
> +	int model, fam;
> +	char *res = NULL;
> +	FILE *f = fopen("/proc/cpuinfo", "r");
> +
> +	if (!f)
> +		return NULL;
> +	while (getline(&line, &llen, f) > 0) {
> +		if (sscanf(line, "vendor_id : %30s", vendor) == 1)
> +			found++;
> +		else if (sscanf(line, "model : %d", &model) == 1)
> +			found++;
> +		else if (sscanf(line, "cpu family : %d", &fam) == 1)
> +			found++;
> +		if (found == 3) {
> +			n = asprintf(&res, "%s-%d-%X-core", vendor, fam, model);
> +			if (n < 0)
> +				res = NULL;
> +			break;
> +		}
> +	}
> +	free(line);
> +	fclose(f);
> +	return res;

we already have arch get_cpuid, which seems to do same thing via cpuid
it would be nice to share those if possible

jirka
