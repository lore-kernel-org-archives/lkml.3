Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3AWLfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:35:24 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:40427 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3AWLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:35:22 -0500
Message-ID: <50FFCA16.5020407@synopsys.com>
Date: Wed, 23 Jan 2013 17:01:34 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.cross-arch
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 60/76] perf, ARC: Enable building perf tools for ARC
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-61-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-61-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 05:55 PM, Vineet Gupta wrote:
> Although with uClibc there's more we need to do
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> ---
>  tools/perf/perf.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 2c340e7..8a68ad3 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -98,6 +98,12 @@ void get_term_dimensions(struct winsize *ws);
>  #define CPUINFO_PROC	"cpu model"
>  #endif
>  
> +#ifdef __arc__
> +#define rmb()		asm volatile("" ::: "memory")
> +#define cpu_relax()	rmb()
> +#define CPUINFO_PROC	"Processor"
> +#endif
> +
>  #include <time.h>
>  #include <unistd.h>
>  #include <sys/types.h>
> 

Hi Arnaldo,

If this looks OK to you, can you please ACK it.

Thx,
-Vineet


