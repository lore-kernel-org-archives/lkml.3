Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaJAPWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaJAPWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:22:31 -0400
Date: Wed, 1 Oct 2014 16:31:15 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20141001153114.GE8971@agordeev.usersys.redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
 <20140924143913.GH16555@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924143913.GH16555@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:39:13AM -0400, Tejun Heo wrote:
> Hello, Alexander.
> 
> On Wed, Sep 24, 2014 at 03:08:44PM +0100, Alexander Gordeev wrote:
> > > Hmmm, how would the whole system benefit from it if there's only
> > > single device?  Each individual servicing of the interrupt does more
> > > now which includes scheduling which may end up adding to completion
> > > latency.
> > 
> > As Chuck noticed, non-AHCI hardware context handlers will benefit.
> 
> Maybe I'm off but I'm kinda skeptical that we'd be gaining back the
> overhead we pay by punting to a thread.

Hi Tejun,

As odd as it sounds, I did not mention there is *no* change in IO
performance at all (in my system): neither with one drive nor two.
The change is only about how the interrupt handlers co-exist with
other devices.

I am attaching excerpts from some new perf tests I have done (this
time in legacy interrupt mode). As you can notice, ahci_interrupt()
CPU time drops from 4% to none.

As of your concern wrt threaded handler invocation overhead - I am
not quite sure here, but if SCHED_FIFO policy (the handler runs with)
makes the difference? Anyway, as said above the overall IO does not
suffer.

> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
