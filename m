Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaJTSU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaJTSU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:20:26 -0400
Date: Mon, 20 Oct 2014 20:20:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/8] tools, perf: Make srcline output address with -v
Message-ID: <20141020182009.GD9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-8-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:15PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When -v is specified always print the hex address for the srcline.

I wasn't able to trigger this kind of output..

could you please update the changelog with the output change
and state the scenario when this is visible?


> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/srcline.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
> index 36a7aff..a22be7c 100644
> --- a/tools/perf/util/srcline.c
> +++ b/tools/perf/util/srcline.c
> @@ -258,6 +258,12 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
>  	unsigned line = 0;
>  	char *srcline;
>  	const char *dso_name;
> +	char astr[50];
> +
> +	if (verbose)
> +		snprintf(astr, sizeof astr, " %#lx", addr);

WARNING: sizeof astr should be sizeof(astr)

thanks,
jirka
