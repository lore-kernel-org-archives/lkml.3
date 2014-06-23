Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaFWRBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:01:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:20807 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaFWRBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,531,1400050800"; 
   d="scan'208";a="532783163"
Subject: Re: [PATCH v2] sched: Fast idling of CPU when system is partially
 loaded
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Jason Low <jason.low2@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Michel Lespinasse <walken@google.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1403541870.2526.12.camel@j-VirtualBox>
References: <1402948127.2970.578.camel@schen9-DESK>
	 <20140623125233.GZ19860@laptop.programming.kicks-ass.net>
	 <20140623162234.GP5714@two.firstfloor.org>
	 <1403541870.2526.12.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jun 2014 10:01:02 -0700
Message-ID: <1403542862.2970.606.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 09:44 -0700, Jason Low wrote:
> On Mon, 2014-06-23 at 18:22 +0200, Andi Kleen wrote:
> > > So I don't get why we can't do the below; I think Jason tried to ask the
> > > same...
> > 
> > The important part for performance is to minimize the cache line transfers. Your
> > unconditional variant would cause more dirty cache lines than Tim's,
> > right?
> 
> How about that change to the update_sg_lb_stats() call site along with:
> 
>                 sgs->group_load += load;
>                 sgs->sum_nr_running += rq->nr_running;
> -               if (overload && rq->nr_running > 1)
> +               if (!env->sd->parent && rq->nr_running > 1)
>                         *overload = true;
> 
> which keeps it as a conditional to avoid unnecessarily setting overload
> when it's not used, and still get those benefits Peter mentioned.

I think this change will satisfy both needs.  I'll re-spin a v3 patch
with this modification if there're no objections.

Tim

