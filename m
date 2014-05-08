Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaEHRxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbaEHRxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:53:32 -0400
Date: Thu, 8 May 2014 13:52:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, andi@firstfloor.org
Subject: Re: [PATCH 1/5] x86, nmi:  Add new nmi type 'external'
Message-ID: <20140508175247.GA39568@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-2-git-send-email-dzickus@redhat.com>
 <20140507153854.GA14926@gmail.com>
 <20140507160251.GQ39568@redhat.com>
 <20140507162746.GA15779@gmail.com>
 <20140508163333.GZ39568@redhat.com>
 <20140508173501.GA9838@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508173501.GA9838@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 07:35:01PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > > > Again, I don't have a solution to juggle between PMI performance 
> > > > and reliable delivery.  We could do away with the spinlocks and 
> > > > go back to single cpu delivery (like it used to be).  Then 
> > > > devise a mechanism to switch delivery to another cpu upon 
> > > > hotplug.
> > > > 
> > > > Thoughts?
> > > 
> > > I'd say we should do a delayed timer that makes sure that all 
> > > possible handlers are polled after an NMI is triggered, but never 
> > > at a high rate.
> > 
> > Hmm, I was thinking about it and wanted to avoid a poll as I hear 
> > complaints here and there about the nmi_watchdog constantly wasting 
> > power cycles with its polling.
> 
> But the polling would only happen if there's NMI traffic, so that's 
> fine. So as long as polling stops some time after the last PMI use, 
> it's a good solution.

So you are thinking an NMI comes in, kicks off a delayed timer for say
10ms.  The timer fires, rechecks the NMI for missed events and then stops?
If another NMI happens before the timer fires, just kick the timer again?

Something like that?

Cheers,
Don
 
> 
> This would also address a lot of NMI handling related fragility.
> 
> Thanks,
> 
> 	Ingo
