Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3EMOEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:04:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:47677 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3EMOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:04:50 -0400
Date: Mon, 13 May 2013 16:04:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robin Holt <holt@sgi.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Full dynticks needs evtdesc set before marking cpu online.
In-Reply-To: <20130513135948.GF3658@sgi.com>
Message-ID: <alpine.LFD.2.02.1305131602090.2863@ionos>
References: <20130508235736.GT3658@sgi.com> <alpine.LFD.2.02.1305131119180.2863@ionos> <20130513125514.GE3658@sgi.com> <alpine.LFD.2.02.1305131501210.2863@ionos> <20130513135948.GF3658@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Robin Holt wrote:
> On Mon, May 13, 2013 at 03:03:55PM +0200, Thomas Gleixner wrote:
> > On Mon, 13 May 2013, Robin Holt wrote:
> > 
> > > On Mon, May 13, 2013 at 11:21:00AM +0200, Thomas Gleixner wrote:
> > > > On Wed, 8 May 2013, Robin Holt wrote:
> > > > 
> > > > > Thomas,
> > > > > 
> > > > > We are seeing failures booting medium sized machines which I think is
> > > > > a change in expectations that dyntick put on x86's start_secondary.
> > > > > 
> > > > > During boot of cpus, we see an occassional panic in tick_do_broadcast at
> > > > 
> > > > http://lkml.indiana.edu/hypermail/linux/kernel/1305.0/01818.html
> > > > 
> > > > Will hit Linus tree soon.
> > > 
> > > I think this is really due to a sequence in start_secondary.  The cpu
> > > has been marked as online, but its evtdesc has not been initialized.
> > > I sent a followup to this with a hack/patch.
> > 
> > No, the real issue is that I messed up the cpumask conversion in the
> > broadcast code, i.e. using alloc instead of zalloc, which allocated
> > nonzeroed memory for the cpumasks, so any random bit set will crash
> > the machine. Your patch is just papering over the issue.
> 
> I believe I understand now.  What would be the downside of moving
> the initialization to before marking the cpu online?  It seems like a
> reasonable this to expect as well in spite of it not being the right
> fix to the other bug.

Yes, we can move it, but its not a required thing that the tick device
is setup befor onlining.

Thanks,

	tglx
