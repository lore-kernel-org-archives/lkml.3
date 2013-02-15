Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027Ab3BOLQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:16:41 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60438 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab3BOLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:16:40 -0500
Date: Fri, 15 Feb 2013 12:16:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/5] lockdep: check that no locks held at freeze time
Message-ID: <20130215111635.GA26955@gmail.com>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
 <1360885096-21207-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360885096-21207-2-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@chromium.org> wrote:

> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -4091,10 +4091,10 @@ static void print_held_locks_bug(struct task_struct *curr)
>  		return;
>  
>  	printk("\n");
> -	printk("=====================================\n");
> -	printk("[ BUG: lock held at task exit time! ]\n");
> +	printk("=======================================\n");
> +	printk("[ BUG: lock held at exit/freeze time! ]\n");

Looks good, but to make it more apparent which case triggers, 
please pass in a 'msg' string that gets printed - and the msg is 
either "exit" or "freeze", depending on from where it's called.

Thanks,

	Ingo
