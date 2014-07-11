Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaGKIPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:15:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGKIO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:14:59 -0400
Date: Fri, 11 Jul 2014 10:14:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 1/4] perf: add ability to sample machine state on
 interrupt
Message-ID: <20140711081424.GA31646@krava.redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:15:56AM +0200, Stephane Eranian wrote:
> Enable capture of interrupted machine state in each
> sample.
> 
> Registers to sample are passed per event in the
> sample_regs_intr bitmask.
> 
> To sample interrupt machine state, the 
> PERF_SAMPLE_INTR_REGS must be passed in
> sample_type.

SNIP

> index 57e9190..018939c 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4296,7 +4296,7 @@ perf_output_sample_regs(struct perf_output_handle *handle,
>  	}
>  }
>  
> -static void perf_sample_regs_user(struct perf_regs_user *regs_user,
> +static void perf_sample_regs_user(struct perf_regs *regs_user,
>  				  struct pt_regs *regs)
>  {
>  	if (!user_mode(regs)) {
> @@ -4312,6 +4312,14 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
>  	}
>  }
>  
> +static void perf_sample_regs_intr(struct perf_regs *regs_user,
> +				  struct pt_regs *regs)
> +{
> +	regs_user->regs = regs;
> +	regs_user->abi  = perf_reg_abi(current);

             ^^^ regs_intr

jirka
