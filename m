Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaGKH6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaGKH6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:58:47 -0400
Date: Fri, 11 Jul 2014 09:58:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 1/4] perf: add ability to sample machine state on
 interrupt
Message-ID: <20140711075808.GA21557@krava.redhat.com>
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
> 
> The list of available registers is arch
> dependent and provided by asm/perf_regs.h
> 
> Registers are laid out as u64 in the order
> of the bit order of sample_intr_regs.

SNIP

>  };
>  
>  /*
> @@ -334,6 +335,15 @@ struct perf_event_attr {
>  
>  	/* Align to u64. */
>  	__u32	__reserved_2;
> +	/*
> +	 * Defines set of user regs to dump on samples.
                          ^^ interrupt 

jirka
