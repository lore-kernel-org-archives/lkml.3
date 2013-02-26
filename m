Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab3BZIuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:50:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:6471 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759303Ab3BZIun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:50:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,739,1355126400"; 
   d="scan'208";a="261479434"
Date: Tue, 26 Feb 2013 16:48:50 +0800
From: Feng Tang <feng.tang@intel.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org
Subject: Re: [PATCH 2/2] perf report: Fix build with NO_NEWT=1
Message-ID: <20130226084850.GA18084@feng-snb>
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
 <1361854923-1814-2-git-send-email-michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361854923-1814-2-git-send-email-michael@ellerman.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 04:02:03PM +1100, Michael Ellerman wrote:
> Commit ad0de09 "Enable the runtime switching of perf data file" broke
> the build with NO_NEWT=1:
> 
>     CC builtin-report.o
> builtin-report.c: In function '__cmd_report':
> builtin-report.c:479:15: error: 'K_SWITCH_INPUT_DATA' undeclared (first use in this function)
> builtin-report.c:479:15: note: each undeclared identifier is reported only once for each function it appears in
> builtin-report.c: In function 'cmd_report':
> builtin-report.c:823:13: error: 'K_SWITCH_INPUT_DATA' undeclared (first use in this function)
> make: *** [builtin-report.o] Error 1
> 
> Fix it by adding a dummy definition of K_SWITCH_INPUT_DATA.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>  tools/perf/util/hist.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 609a115..226a4ae 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -210,6 +210,7 @@ static inline int script_browse(const char *script_opt __maybe_unused)
>  
>  #define K_LEFT  -1000
>  #define K_RIGHT -2000
> +#define K_SWITCH_INPUT_DATA -3000

Both patches look good to me, thanks for the fix. But can we use
a better value? -1000, -2000 looks a little awkward.

- Feng
