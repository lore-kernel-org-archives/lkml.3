Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab3E3OWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:22:17 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:53725 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3E3OWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:22:07 -0400
Date: Thu, 30 May 2013 16:22:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Bohac <jbohac@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] nohz: Prevent broadcast source from stealing full
 dynticks timekeeping duty
Message-ID: <20130530142200.GA23384@somewhere>
References: <1369845580-15273-1-git-send-email-fweisbec@gmail.com>
 <1369845580-15273-2-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.02.1305301554100.2905@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305301554100.2905@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 03:57:17PM +0200, Thomas Gleixner wrote:
> On Wed, 29 May 2013, Frederic Weisbecker wrote:
> 
> > The timekeeping duty is currently assigned to the CPU that
> > handles the tick broadcast clock device by the time it is set in
> > one shot mode.
> > 
> > The reason for this is not entirely clear as outlined by Jiri
> > Bohac: https://patchwork.kernel.org/patch/2302951/
> > 
> > One could speculate though that it makes sure only one CPU
> > is woken up to fixup the timekeeping max deferment. But the
> > timekeeper can change anytime after the broadcast CPU becomes
> > idle. So probably we can remove this as in Jiri's patch, but
> > not late in the -rc's.
> 
> Looking at commit 7300711e (clockevents: broadcast fixup possible
> waiters) which introduced that takeover, I really can't see a reason
> why we must do that. It's safe to remove it completely even now.

Yeah it seems so, if you're ok I can commit https://patchwork.kernel.org/patch/2302951/
with your ack and send another pull request.

Thanks.
