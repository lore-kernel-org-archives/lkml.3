Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaAATSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 14:18:45 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43161 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaAATSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 14:18:43 -0500
Date: Wed, 1 Jan 2014 11:18:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "Felipe F. Tonello" <eu@felipetonello.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] input: mt: Add helper function to send end events
Message-ID: <20140101191838.GA30798@core.coreip.homeip.net>
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
 <52C28DC7.9020003@euromail.se>
 <20131231185035.GD6897@core.coreip.homeip.net>
 <52C43FFE.3010005@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C43FFE.3010005@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 01, 2014 at 05:19:10PM +0100, Henrik Rydberg wrote:
> Hi Dmitry,
> 
> >> What problematic scenario is this supposed to solve?
> >>
> >> The 'release on suspend' is only an approximation to the 'close
> >> laptop' scenario, it is certainly not correct in the coffee table
> >> case,
> > 
> > Why would it not be correct for coffee table? Do we expect the touches
> > to remain valid while the device is asleep?
> 
> In some scenarios with placed objects (like a cup or a marker), that would be
> the case, yes.
> 
> >> for instance. Instead of
> >> hardcoding this in the kernel, userland can easily detect long intervals
> >> directly using the event time.
> > 
> > But with slots it is not only problem with old events being sent out
> > later, it is that we have mix of old (pre-sleep) and new state.
> 
> The new state is not really a problem, it will look exactly the same regardless
> of how 'old' releases are handled.
> 
> > We do that for keys (release them when we transition to system sleep)
> > and I think it might be worthwhile to do the same for touch data.
> 
> I agree that keyboard applications seldom look at time intervals and hence are
> well helped by such a strategy, even though it is not strictly 'correct'.
> However, touch interfaces are quite dependent on time intervals, and it
> therefore makes a lot of sense to resolve touch timeouts directly in the
> application. It also puts less restrictions on what can be done.
> 
> Regarding notifications in general, perhaps it would be interesting to be able
> to send a notification event via the input interface when a device comes back
> from sleep. It could help resolve other complex issues, if there were any.
> 

OK, fair enough. If there is a demand we could send SYN_SYSTEM_RESUME
event though the interfaces to allow clients "flush" the state or
otherwise decide if new touch data is actually old touches that were
there pre-suspend.

Felipe, will that help in your case?

Thanks.

-- 
Dmitry
