Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3A1VSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:18:40 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:62311 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3A1VSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:18:37 -0500
Date: Mon, 28 Jan 2013 13:18:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128211832.GK22465@mtj.dyndns.org>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
 <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128205540.GE26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, Jan 28, 2013 at 12:55:40PM -0800, Kent Overstreet wrote:
> > I don't understand why we need two stages. What prevents the killing
> > thread from fetching percpu counters after dying passes one
> > synchronize_sched()?
> 
> It does. The second synchronize_sched() is needed after we set state :=
> dead, and before we drop the initial ref. Otherwise the ref could hit 0
> before percpu_ref_put knows to check for it.

Still a bit confused.  Why do we need to make the two steps separate?
What prevents us from doing the following?

	set dying;
	synchronize_sched();
	collect percpu refs into global atomic_t;
	put the base ref;

Thanks.

-- 
tejun
