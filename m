Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3EaJKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:10:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56935 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3EaJKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:10:23 -0400
Date: Fri, 31 May 2013 11:10:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 04/16] perf, persistent: Print error code on failure when
 adding events
Message-ID: <20130531091034.GE14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-5-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-5-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:24AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> Improve error reporting.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  kernel/events/persistent.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
> index 1e6c03a..6612eb77 100644
> --- a/kernel/events/persistent.c
> +++ b/kernel/events/persistent.c
> @@ -123,15 +123,15 @@ int perf_add_persistent_event(struct perf_event_attr *attr, unsigned nr_pages)
>  
>  	for_each_possible_cpu(i) {
>  		event = add_persistent_event_on_cpu(i, attr, nr_pages);
> -		if (IS_ERR(event)) {
> -			pr_err("%s: Error adding persistent event on cpu %d\n",
> -				__func__, i);
> +		if (IS_ERR(event))
>  			goto unwind;
> -		}
>  	}
>  	return 0;
>  
>  unwind:
> +	pr_err("%s: Error adding persistent event on cpu %d: %ld\n",
> +		__func__, i, PTR_ERR(event));
> +
>  	while (--i >= 0)
>  		del_persistent_event(i, attr);

Should also be merged.

Thanks.
