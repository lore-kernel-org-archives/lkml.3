Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3HZNJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:09:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:40222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3HZNJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:09:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="351691604"
Message-ID: <521B54F6.5060304@intel.com>
Date: Mon, 26 Aug 2013 16:15:34 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf: add a dummy software event to keep tracking
References: <1375882231-18339-1-git-send-email-adrian.hunter@intel.com> <1375882231-18339-2-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1375882231-18339-2-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/13 16:30, Adrian Hunter wrote:
> When an event is disabled the "tracking" events
> selected by the 'mmap', 'comm' and 'task' bits of
> struct perf_event_attr, are also disabled.  However,
> the information those events provide is necessary to
> resolve symbols for when the main event is re-enabled.
> 
> The "tracking" events can be kept enabled by putting
> them on another event, but that requires an event
> that otherwise does nothing.  A new software event
> PERF_COUNT_SW_DUMMY is added for that purpose.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Any comments?

> ---
>  include/uapi/linux/perf_event.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 62c25a2..9e28422 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -109,6 +109,7 @@ enum perf_sw_ids {
>  	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
>  	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
>  	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
> +	PERF_COUNT_SW_DUMMY			= 9,
>  
>  	PERF_COUNT_SW_MAX,			/* non-ABI */
>  };
> 

