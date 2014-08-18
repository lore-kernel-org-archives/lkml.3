Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaHRPRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaHRPRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:17:42 -0400
Date: Mon, 18 Aug 2014 11:17:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818151737.GT49576@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
 <20140818091644.GE25495@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818091644.GE25495@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:16:44AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > The running kernel still has the ability to enable/disable at any
> > time with /proc/sys/kernel/nmi_watchdog us usual. However even
> > when the default has been overridden /proc/sys/kernel/nmi_watchdog
> > will initially show '1'. To truly turn it on one must disable/enable
> > it, i.e.
> >   echo 0 > /proc/sys/kernel/nmi_watchdog
> >   echo 1 > /proc/sys/kernel/nmi_watchdog
> 
> This looks like a bug, why is this so?

It is, but it always has been there in the case of the PMU not being able
to provide a resource for the hardlockup.  This change just exposes it
more.

Originally I wrote the code to keep the softlockup and hardlockup in sync.
Now this patch attempts to split it up because the guest PMU is still
flushing out bugs.

The above scenario only really applies to developers.  Their guest boots
up with the hardlockup disabled.  If they want to enable it to debug or
develop, they have to go with the above steps.  The idea is once the KVM
PMU is stable enough, the default switches to hardlockup enabled by
default and this problem kinda goes back to one it is today.

I guess I was feeling lazy about modifying a bunch of code to separate the
hard and soft lockup for a temporarily broken feature.  :-/

I thought it would just be easier to put this code in to quickly stabilize
their PMU and switch the default later.

Thoughts?  I think Uli laid out a more detailed example in his email.

Cheers,
Don

