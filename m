Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3EaJF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:05:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3EaJFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:05:49 -0400
Date: Fri, 31 May 2013 11:05:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 02/16] perf, persistent: Fix attr size
Message-ID: <20130531090559.GC14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-3-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-3-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:22AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> Fixing wrongly determined attribute size.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  kernel/events/persistent.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
> index 5335644..9075164 100644
> --- a/kernel/events/persistent.c
> +++ b/kernel/events/persistent.c
> @@ -149,7 +149,7 @@ int perf_add_persistent_event_by_id(int id)
>  	attr->persistent	= 1;
>  	attr->config		= id;
>  	attr->type		= PERF_TYPE_TRACEPOINT;
> -	attr->size		= sizeof(attr);
> +	attr->size		= sizeof(*attr);

Ditto for this one.
