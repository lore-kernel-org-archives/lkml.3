Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaHTLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:25:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:38824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaHTLZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:25:53 -0400
Date: Wed, 20 Aug 2014 08:25:49 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, eranian@google.com,
        LKML <linux-kernel@vger.kernel.org>, Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH] perf, map:  Don't try to find DSOs in SYSV maps
Message-ID: <20140820112549.GB2892@kernel.org>
References: <1408501874-244377-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408501874-244377-1-git-send-email-dzickus@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 19, 2014 at 10:31:14PM -0400, Don Zickus escreveu:
> We are seeing a lot of the following with regards to SYSV memory
> 
> Failed to open /SYSV0000279c, continuing without symbols
> 
> We don't believe this memory will have DSO info, so treat it like the heap and
> stack for now and skip it to prevent the warning.

Thanks, applied.
 
> Signed-off-by: Joe Mario <jmario@redhat.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> --
> I am open to suggetions for a different fix - dcz
> ---
>  tools/perf/util/map.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 25c571f..0294f40 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -29,6 +29,7 @@ static inline int is_anon_memory(const char *filename)
>  static inline int is_no_dso_memory(const char *filename)
>  {
>  	return !strncmp(filename, "[stack", 6) ||
> +	       !strncmp(filename, "/SYSV",5)   ||
>  	       !strcmp(filename, "[heap]");
>  }
>  
> -- 
> 1.7.1
