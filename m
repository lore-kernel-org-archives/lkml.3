Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3DXGsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:48:18 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35757 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3DXGsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:48:17 -0400
Date: Wed, 24 Apr 2013 08:48:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print out additional debugging advice when we hit lockdep BUGs
Message-ID: <20130424064813.GB27551@gmail.com>
References: <20130423163403.GA12839@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130423163403.GA12839@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> We occasionally get reports of these BUGs being hit, and the stack trace
> doesn't necessarily always tell us what we need to know about why we are
> hitting those limits.
> 
> If users start attaching /proc/lock_stats to reports we may have more of
> a clue what's going on.

Good idea.

A detail:

>  		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
>  		printk("turning off the locking correctness validator.\n");
> +		printk("Attach output of /proc/lock_stat to bug report\n");

>  		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
>  		printk("turning off the locking correctness validator.\n");
> +		printk("Attach output of /proc/lock_stat to bug report\n");

>  		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
>  		printk("turning off the locking correctness validator.\n");
> +		printk("Attach output of /proc/lock_stat to bug report\n");

>  		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
>  		printk("turning off the locking correctness validator.\n");
> +		printk("Attach output of /proc/lock_stat to bug report\n");

>  		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
>  		       curr->lockdep_depth, MAX_LOCK_DEPTH);
>  		printk("turning off the locking correctness validator.\n");
> +		printk("Attach output of /proc/lock_stat to bug report\n");

These patterns repeated in 4 places really call for a common helper 
defined as print_lockdep_off(fmt...) or so?

(Can be a followup patch if that's easier for you.)

Thanks,

	Ingo
