Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3EaJK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:10:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56949 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab3EaJKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:10:50 -0400
Date: Fri, 31 May 2013 11:11:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: Re: [PATCH 05/16] perf, persistent: Return resonable error code
Message-ID: <20130531091101.GF14076@nazgul.tnic>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
 <1369990056-10310-6-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369990056-10310-6-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:47:25AM +0200, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> Returning -ENODEV if no file descriptor is found. An error code of -1
> (-EPERM) is misleading in this case.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  kernel/events/persistent.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
> index 6612eb77..190aa75 100644
> --- a/kernel/events/persistent.c
> +++ b/kernel/events/persistent.c
> @@ -165,7 +165,7 @@ int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
>  		if (desc->attr->config == attr->config)
>  			return __alloc_persistent_event_fd(desc);
>  
> -	return -1;
> +	return -ENODEV;

Ditto.
