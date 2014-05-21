Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaEUTDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:03:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:51659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaEUTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:03:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,881,1392192000"; 
   d="scan'208";a="544422945"
Subject: Re: [RFC PATCH] mutex: Documentation rewrite
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        waiman.long@hp.com, jason.low2@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
References: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 May 2014 12:02:56 -0700
Message-ID: <1400698977.2970.308.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 10:41 -0700, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> Our mutexes have gone a long ways since the original implementation
> back in 2005/2006. However, the mutex-design.txt document is still
> stuck in the past, to the point where most of the information there
> is practically useless and, more important, simply incorrect. This
> patch pretty much rewrites it to resemble what we have nowadays.
> 
> Since regular semaphores are almost much extinct in the kernel
> (most users now rely on mutexes or rwsems), it no longer makes
> sense to have such a close comparison, which was copied from most
> of the cover letter when Ingo introduced the generic mutex subsystem.
> 
> While users who really want to learn more about kernel mutexes can
> go and read the code, I have marked this RFC since I'm sure more gory
> details can be included. Also, ww_mutexes are intentionally left out,
> leaving things as generic as possible.
> 
> Comments welcome!

Thanks for doing this.

> +
> +(iii) slowpath: last resource, if the lock is still unable to be acquired

change "last resource" to "last resort"


>  
>  Disadvantages
>  -------------
>  
> -The stricter mutex API means you cannot use mutexes the same way you
> -can use semaphores: e.g. they cannot be used from an interrupt context,
> -nor can they be unlocked from a different context that which acquired
> -it. [ I'm not aware of any other (e.g. performance) disadvantages from
> -using mutexes at the moment, please let me know if you find any. ]
> -

Should we keep this instead of deleting it?  It is still true we
cannot use mutex from an interrupt context.

Tim

