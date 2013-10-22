Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3JVKin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:38:43 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:35609 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574Ab3JVKim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:38:42 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2013 06:38:42 EDT
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 22 Oct 2013 14:32:23 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf timechart: remove lock_depth from trace_entry
Message-ID: <20131022103223.GA29489@stfomichev-desktop>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 02:48:34PM +0800, Chia-I Wu wrote:
> struct trace_entry went out-of-sync with the kernel since
> 
>  commit b000c8065 "tracing: Remove the extra 4 bytes of padding in events"
> 
> causing "perf timechart" to be broken.
> 
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Stanislav Fomichev <stfomichev@yandex-team.ru>

For some reason nobody noticed this patch on lkml, so resending to the
maintainers...
This also makes sense to merge it into the stable line.

> ---
>  tools/perf/builtin-timechart.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
> index c2e0231..f9cbc18 100644
> --- a/tools/perf/builtin-timechart.c
> +++ b/tools/perf/builtin-timechart.c
> @@ -303,7 +303,6 @@ struct trace_entry {
>  	unsigned char		flags;
>  	unsigned char		preempt_count;
>  	int			pid;
> -	int			lock_depth;
>  };
>  
>  #ifdef SUPPORT_OLD_POWER_EVENTS
> -- 
> 1.8.3.1
