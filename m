Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaKMTXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:23:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:55736 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbaKMTXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:23:04 -0500
Date: Thu, 13 Nov 2014 16:22:58 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 07/10] perf, tools: Only print base source file for
 srcline
Message-ID: <20141113192258.GH3612@kernel.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415844328-4884-8-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 12, 2014 at 06:05:25PM -0800, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For perf report with --sort srcline only print the base source file
> name. This makes the results generally fit much better to the
> screen. The path is usually not that useful anyways because it is
> often from different systems.

Applied
 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/srcline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
> index c6a7cdc..ac877f9 100644
> --- a/tools/perf/util/srcline.c
> +++ b/tools/perf/util/srcline.c
> @@ -274,7 +274,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
>  	if (!addr2line(dso_name, addr, &file, &line, dso))
>  		goto out;
>  
> -	if (asprintf(&srcline, "%s:%u", file, line) < 0) {
> +	if (asprintf(&srcline, "%s:%u", basename(file), line) < 0) {
>  		free(file);
>  		goto out;
>  	}
> -- 
> 1.9.3
