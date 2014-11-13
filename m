Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbaKMTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:16:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:55160 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933528AbaKMTQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:16:37 -0500
Date: Thu, 13 Nov 2014 16:16:33 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/10] perf, tools: Use al.addr to set up call chain
Message-ID: <20141113191633.GE3612@kernel.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415844328-4884-4-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 12, 2014 at 06:05:21PM -0800, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Use the relative address, this makes get_srcline work correctly
> in the end.

Applied.
 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/machine.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 2e16d69..066e963 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1411,7 +1411,7 @@ static int add_callchain_ip(struct thread *thread,
>  		}
>  	}
>  
> -	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
> +	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
>  }
>  
>  struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
> -- 
> 1.9.3
