Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab3E1It5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:49:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:16024 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933619Ab3E1It4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:49:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,756,1363158000"; 
   d="scan'208";a="344388294"
Message-ID: <1369730992.29283.224.camel@smile>
Subject: Re: [PATCH] 9p: trace: use %*ph to dump buffer
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 11:49:52 +0300
In-Reply-To: <1366635713-11435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1366635713-11435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 16:01 +0300, Andy Shevchenko wrote: 
> Additionally change cast from long to unsigned long to follow specificator.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/trace/events/9p.h | 28 +++-------------------------
>  1 file changed, 3 insertions(+), 25 deletions(-)
> 
> diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
> index beeaed8..a066636 100644
> --- a/include/trace/events/9p.h
> +++ b/include/trace/events/9p.h
> @@ -143,31 +143,9 @@ TRACE_EVENT(9p_protocol_dump,
>  		    __entry->tag    =  pdu->tag;
>  		    memcpy(__entry->line, pdu->sdata, P9_PROTO_DUMP_SZ);
>  		    ),
> -	    TP_printk("clnt %lu %s(tag = %d)\n%.3x: "
> -		      "%02x %02x %02x %02x %02x %02x %02x %02x "
> -		      "%02x %02x %02x %02x %02x %02x %02x %02x\n"
> -		      "%.3x: "
> -		      "%02x %02x %02x %02x %02x %02x %02x %02x "
> -		      "%02x %02x %02x %02x %02x %02x %02x %02x\n",
> -		      (long)__entry->clnt, show_9p_op(__entry->type),
> -		      __entry->tag, 0,
> -		      __entry->line[0],  __entry->line[1],
> -		      __entry->line[2],  __entry->line[3],
> -		      __entry->line[4],  __entry->line[5],
> -		      __entry->line[6],  __entry->line[7],
> -		      __entry->line[8],  __entry->line[9],
> -		      __entry->line[10], __entry->line[11],
> -		      __entry->line[12], __entry->line[13],
> -		      __entry->line[14], __entry->line[15],
> -		      16,
> -		      __entry->line[16], __entry->line[17],
> -		      __entry->line[18], __entry->line[19],
> -		      __entry->line[20], __entry->line[21],
> -		      __entry->line[22], __entry->line[23],
> -		      __entry->line[24], __entry->line[25],
> -		      __entry->line[26], __entry->line[27],
> -		      __entry->line[28], __entry->line[29],
> -		      __entry->line[30], __entry->line[31])
> +	    TP_printk("clnt %lu %s(tag = %d)\n%.3x: %16ph\n%.3x: %16ph\n",
> +		      (unsigned long)__entry->clnt, show_9p_op(__entry->type),
> +		      __entry->tag, 0, __entry->line, 16, __entry->line + 16)
>   );
>  
>  #endif /* _TRACE_9P_H */

Any comment on this one, anyone?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
