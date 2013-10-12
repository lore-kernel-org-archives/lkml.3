Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3JLOlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 10:41:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3JLOlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 10:41:07 -0400
Date: Sat, 12 Oct 2013 16:40:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: lockdep: testing '0' where '\0' intended?
Message-ID: <20131012144057.GA2675@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1310120043280.11060@Z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310120043280.11060@Z>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 01:06:03AM +0200, Roel Kluin wrote:
> Not entirely sure about the assembly part, but shouldn't it...
> --------
> Test for the nul character rather than the '0' (== 0x30), in the
> __get_user_unknown() case.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index b2c71c5..71b3aba 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -632,7 +632,7 @@ static ssize_t lock_stat_write(struct file *file, 
> const char __user *buf,
>  		if (get_user(c, buf))
>  			return -EFAULT;
>  
> -		if (c != '0')
> +		if (c != '\0')

No we really meant '0'. Its so that:

  echo 0 > /proc/lock_stat

resets the stats.
