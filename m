Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3JIB5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab3JIB5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:57:37 -0400
Date: Tue, 8 Oct 2013 22:22:30 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, dzickus@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
Message-ID: <20131009012230.GA27210@amt.cnet>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.779616517@amt.cnet>
 <5253D732.8060906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5253D732.8060906@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 11:58:10AM +0200, Paolo Bonzini wrote:
> Il 08/10/2013 03:05, Marcelo Tosatti ha scritto:
> > +void pvclock_touch_watchdogs(void)
> > +{
> > +	touch_softlockup_watchdog_sync();
> > +	clocksource_touch_watchdog();
> > +	rcu_cpu_stall_reset();
> > +	reset_hung_task_detector();
> > +}
> > +
> 
> Should this function be in kernel/ instead?  It's not really
> pvclock-specific.
> 
> Paolo

kernel/watchdog.c is configurable via CONFIG_LOCKUP_DETECTOR, so its not
appropriate.

And, the choice of watchdogs to reset might be different for the caller.

