Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3FFUog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:44:36 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32768 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3FFUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:44:32 -0400
Date: Thu, 6 Jun 2013 13:44:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: greearb@candelatech.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix lockup related to stop_machine being stuck in
 __do_softirq.
Message-ID: <20130606204428.GA5045@htj.dyndns.org>
References: <1370492751-6886-1-git-send-email-greearb@candelatech.com>
 <1370492994.24311.331.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370492994.24311.331.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 09:29:54PM -0700, Eric Dumazet wrote:
> On Wed, 2013-06-05 at 21:25 -0700, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> 
> > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > index 14d7758..f150ad6 100644
> > --- a/kernel/softirq.c
> > +++ b/kernel/softirq.c
> > @@ -204,6 +204,7 @@ EXPORT_SYMBOL(local_bh_enable_ip);
> >   * should not be able to lock up the box.
> 
> Could you update the comment ?
> 
> I had the following :
> 
> - * We restart softirq processing for at most 2 ms,
> - * and if need_resched() is not set.
> + * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
> + * but break the loop if need_resched() is set or after 2 ms.

It'd be nice to briefly explain why both protections are necessary in
the comment and maybe cite this thread.  Also, please cc Linus when
posting the next round and I think we still want to find out what's
going on with infinite softirq, I'll reply in the original thread.

Thanks a lot!

-- 
tejun
