Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaDYFf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 01:35:58 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61635 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaDYFf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 01:35:56 -0400
Message-ID: <1398404153.7893.10.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sysrq,rcu: suppress RCU stall warnings while sysrq
 runs
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, joern@logfs.org, peterz@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Date: Fri, 25 Apr 2014 07:35:53 +0200
In-Reply-To: <20140424090452.3482f95c@annuminas.surriel.com>
References: <20140423125352.704f9fb2@annuminas.surriel.com>
	 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
	 <535833AE.6010505@redhat.com>
	 <alpine.LRH.2.00.1404232349350.1491@twin.jikos.cz>
	 <20140424014648.GK4496@linux.vnet.ibm.com>
	 <20140424090452.3482f95c@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 09:04 -0400, Rik van Riel wrote:

> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index 4c0a9b0..2ac3289 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -320,6 +320,17 @@ int rcu_jiffies_till_stall_check(void)
>  	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
>  }
>  
> +void rcu_sysrq_start(void)
> +{
> +	rcu_cpu_stall_suppress = 2;
> +}

Monster box folks seem to routinely kill that at boot, probably won't
want it coming back to life at the poke of a button.

-Mike

