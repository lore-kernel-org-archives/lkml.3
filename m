Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3EaJFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:05:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50690 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3EaJFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:05:16 -0400
Date: Fri, 31 May 2013 11:05:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 01/16] perf, persistent: Fix build error for
 no-tracepoints configs
Message-ID: <20130531090527.GB14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-2-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-2-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:21AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> The mce_record tracepoint needs tracepoints to be enabled. Fixing
> build error for no-tracepoints configs.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 0ecf4a2..d421937 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1987,6 +1987,8 @@ int __init mcheck_init(void)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_TRACEPOINTS
> +
>  int __init mcheck_init_tp(void)
>  {
>  	if (perf_add_persistent_event_by_id(event_mce_record.event.type)) {
> @@ -2001,6 +2003,8 @@ int __init mcheck_init_tp(void)
>   */
>  fs_initcall_sync(mcheck_init_tp);
>  
> +#endif /* CONFIG_TRACEPOINTS */
> +

Right, since my persistent patches are in no tree yet, we should merge
this one with, I think, the last one in my set and keep them all
together.

Thanks.
