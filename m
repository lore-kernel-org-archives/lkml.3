Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaDXJDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:03:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50091 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbaDXJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:03:49 -0400
Date: Thu, 24 Apr 2014 14:33:41 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes/tracing: uprobe_perf_open() forgets to
 handle	the error from uprobe_apply()
Message-ID: <20140424090341.GA6437@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140423165808.GA29485@redhat.com>
 <20140423165830.GA29493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140423165830.GA29493@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042409-9574-0000-0000-00000D38162F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
(with 2 nits that you can ignore)

>  		done = tu->filter.nr_systemwide ||
> -			event->parent || event->attr.enable_on_exec ||
> +			(event->hw.tp_target->flags & PF_EXITING) ||
>  			uprobe_filter_event(tu, event);
> -		list_add(&event->hw.tp_list, &tu->filter.perf_events);
>  	} else {
> +		tu->filter.nr_systemwide--;
>  		done = tu->filter.nr_systemwide;
> -		tu->filter.nr_systemwide++;
>  	}

Nit: I think 2 lines can be made into
 done = --tu->filter.nr_systemwide;


<snipped>
>  		done = tu->filter.nr_systemwide ||
> -			(event->hw.tp_target->flags & PF_EXITING) ||
> +			event->parent || event->attr.enable_on_exec ||
>  			uprobe_filter_event(tu, event);
> +		list_add(&event->hw.tp_list, &tu->filter.perf_events);
>  	} else {
> -		tu->filter.nr_systemwide--;
>  		done = tu->filter.nr_systemwide;
> +		tu->filter.nr_systemwide++;
>  	}

Nit: Similarly lines can be made into
 done = tu->filter.nr_systemwide++;


-- 
Thanks and Regards
Srikar Dronamraju

