Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3LBPXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:23:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:26336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab3LBPXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:23:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,811,1378882800"; 
   d="scan'208";a="443214122"
Date: Mon, 2 Dec 2013 07:23:29 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [BUG] perf stat: explicit grouping yields unexpected results
Message-ID: <20131202152329.GD22695@tassilo.jf.intel.com>
References: <CABPqkBTiBHF4wZ3c_Czkh3JgvXGNWJW1LH42Jh4NG_ZJkGkbgw@mail.gmail.com>
 <20131115063457.GB12442@gmail.com>
 <CABPqkBQ2wD_knJP9FQxThSxNng4DZhtRxeUUAW0efAs9=jBXEA@mail.gmail.com>
 <20131115103405.GA18264@gmail.com>
 <20131117034134.GA19762@tassilo.jf.intel.com>
 <20131129133340.GA25751@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129133340.GA25751@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Something like below? user space supply buffer for error string.

That would work, although I was thinking of making it a more
generic mechanism (store it into task_struct, have a extra
syscall to retrieve)

-Andi

> 
> jirka
> 
> 
> ---
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index e1802d6..a827870 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -331,8 +331,8 @@ struct perf_event_attr {
>  	 */
>  	__u32	sample_stack_user;
>  
> -	/* Align to u64. */
> -	__u32	__reserved_2;
> +	__u32	errstr_size;
> +	char	*errstr;
>  };
>  
>  #define perf_flags(attr)	(*(&(attr)->read_format + 1))
> 

-- 
ak@linux.intel.com -- Speaking for myself only
