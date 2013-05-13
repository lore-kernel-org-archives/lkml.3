Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3EMN7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:59:51 -0400
Received: from relay2.sgi.com ([192.48.179.30]:41553 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753906Ab3EMN7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:59:49 -0400
Date: Mon, 13 May 2013 08:59:48 -0500
From: Robin Holt <holt@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: Full dynticks needs evtdesc set before marking cpu online.
Message-ID: <20130513135948.GF3658@sgi.com>
References: <20130508235736.GT3658@sgi.com>
 <alpine.LFD.2.02.1305131119180.2863@ionos>
 <20130513125514.GE3658@sgi.com>
 <alpine.LFD.2.02.1305131501210.2863@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305131501210.2863@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 03:03:55PM +0200, Thomas Gleixner wrote:
> On Mon, 13 May 2013, Robin Holt wrote:
> 
> > On Mon, May 13, 2013 at 11:21:00AM +0200, Thomas Gleixner wrote:
> > > On Wed, 8 May 2013, Robin Holt wrote:
> > > 
> > > > Thomas,
> > > > 
> > > > We are seeing failures booting medium sized machines which I think is
> > > > a change in expectations that dyntick put on x86's start_secondary.
> > > > 
> > > > During boot of cpus, we see an occassional panic in tick_do_broadcast at
> > > 
> > > http://lkml.indiana.edu/hypermail/linux/kernel/1305.0/01818.html
> > > 
> > > Will hit Linus tree soon.
> > 
> > I think this is really due to a sequence in start_secondary.  The cpu
> > has been marked as online, but its evtdesc has not been initialized.
> > I sent a followup to this with a hack/patch.
> 
> No, the real issue is that I messed up the cpumask conversion in the
> broadcast code, i.e. using alloc instead of zalloc, which allocated
> nonzeroed memory for the cpumasks, so any random bit set will crash
> the machine. Your patch is just papering over the issue.

I believe I understand now.  What would be the downside of moving
the initialization to before marking the cpu online?  It seems like a
reasonable this to expect as well in spite of it not being the right
fix to the other bug.

Thanks,
Robin
