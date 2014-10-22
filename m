Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaJVT3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:29:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:39758 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaJVT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:29:43 -0400
Date: Wed, 22 Oct 2014 16:29:33 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf tool: add hists__init for perf diff
Message-ID: <20141022192933.GB14687@kernel.org>
References: <1414004561-22096-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414004561-22096-1-git-send-email-kan.liang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 22, 2014 at 03:02:41PM -0400, kan.liang@intel.com escreveu:
> From: Kan Liang <kan.liang@intel.com>
> 
> perf diff also uses hists/hist_entries, hists__init() should be called
> before creating any evsels.

Thanks, this one merits perf/urgent :-\

- Arnaldo
 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  tools/perf/builtin-diff.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 8c5c11c..25114c9 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -1142,6 +1142,11 @@ static int data_init(int argc, const char **argv)
>  
>  int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
> +	int ret = hists__init();
> +
> +	if (ret < 0)
> +		return ret;
> +
>  	perf_config(perf_default_config, NULL);
>  
>  	argc = parse_options(argc, argv, options, diff_usage, 0);
> -- 
> 1.8.3.2
