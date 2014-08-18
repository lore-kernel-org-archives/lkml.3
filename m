Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaHRSxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaHRSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:53:36 -0400
Date: Mon, 18 Aug 2014 14:53:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818185332.GC49576@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
 <20140818091644.GE25495@gmail.com>
 <20140818151737.GT49576@redhat.com>
 <20140818180735.GB4540@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818180735.GB4540@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 08:07:35PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Mon, Aug 18, 2014 at 11:16:44AM +0200, Ingo Molnar wrote:
> > > 
> > > * Don Zickus <dzickus@redhat.com> wrote:
> > > 
> > > > The running kernel still has the ability to enable/disable at any
> > > > time with /proc/sys/kernel/nmi_watchdog us usual. However even
> > > > when the default has been overridden /proc/sys/kernel/nmi_watchdog
> > > > will initially show '1'. To truly turn it on one must disable/enable
> > > > it, i.e.
> > > >   echo 0 > /proc/sys/kernel/nmi_watchdog
> > > >   echo 1 > /proc/sys/kernel/nmi_watchdog
> > > 
> > > This looks like a bug, why is this so?
> > 
> > It is, but it always has been there in the case of the PMU 
> > not being able to provide a resource for the hardlockup.  
> > This change just exposes it more.
> 
> There seems to be two issues:
> 
> 1)
> 
> When it's impossible to enable the hardlockup detector, it 
> should default to -1 or so, and attempts to set it should 
> return a -EINVAL or so.

Ok, it didn't because I set the knob to mean both hard and soft lockup.
But the code knows the failures and can set to -1 if it had to.

> 
> Bootup messages should also indicate when it's not possible to 
> enable it but a user requests it.

It does today.

> 
> 2)
> 
> The softlockup and hardlockup detection control variables 
> should be in separate flags, inside and outside the kernel - 
> they (should) not relate to each other.

They did because years ago I thought we wanted to keep them as one entity
instead of two.  I would have to re-work the code to do this (and add more
knobs).

I presume you would want those changes done before taking this patchset?

Cheers,
Don
