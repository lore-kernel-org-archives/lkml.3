Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaHRSHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:07:41 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:49856 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHRSHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:07:40 -0400
Date: Mon, 18 Aug 2014 20:07:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 4/5] watchdog: control hard lockup detection default
Message-ID: <20140818180735.GB4540@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-5-git-send-email-dzickus@redhat.com>
 <20140818091644.GE25495@gmail.com>
 <20140818151737.GT49576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818151737.GT49576@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Mon, Aug 18, 2014 at 11:16:44AM +0200, Ingo Molnar wrote:
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > The running kernel still has the ability to enable/disable at any
> > > time with /proc/sys/kernel/nmi_watchdog us usual. However even
> > > when the default has been overridden /proc/sys/kernel/nmi_watchdog
> > > will initially show '1'. To truly turn it on one must disable/enable
> > > it, i.e.
> > >   echo 0 > /proc/sys/kernel/nmi_watchdog
> > >   echo 1 > /proc/sys/kernel/nmi_watchdog
> > 
> > This looks like a bug, why is this so?
> 
> It is, but it always has been there in the case of the PMU 
> not being able to provide a resource for the hardlockup.  
> This change just exposes it more.

There seems to be two issues:

1)

When it's impossible to enable the hardlockup detector, it 
should default to -1 or so, and attempts to set it should 
return a -EINVAL or so.

Bootup messages should also indicate when it's not possible to 
enable it but a user requests it.

2)

The softlockup and hardlockup detection control variables 
should be in separate flags, inside and outside the kernel - 
they (should) not relate to each other.

Thanks,

	Ingo
