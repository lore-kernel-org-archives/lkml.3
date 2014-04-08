Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaDHKh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:37:56 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58824 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaDHKhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:37:54 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RESEND] drivercore: deferral race condition fix
To: Mark Brown <broonie@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: gregkh@linuxfoundation.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140403094059.GR14763@sirena.org.uk>
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com> < 20140403094059.GR14763@sirena.org.uk>
Date: Tue, 08 Apr 2014 11:27:31 +0100
Message-Id: <20140408102731.6C331C40933@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2014 10:40:59 +0100, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 03, 2014 at 10:12:07AM +0300, Peter Ujfalusi wrote:
> > When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
> > when all modules loaded but some driver still stuck in the deferred list
> > and there is a need for external event to kick the deferred queue to probe
> > these drivers.
> 
> Acked-by: Mark Brown <broonie@linaro.org>

It's a pretty crude solution though. The problem is any "in-flight"
probes that are going to defer will not get added to the active list.
Rerunning the entire active list is a bit much (but it does have the
advantage of still being conceptually simple). I think we can do better.

Instead of running the entire list, we could add a check to
driver_deferred_probe_add() that adds the device to the active list
instead of pending list on the condition that another driver probe
completed while the deferred probe was in-flight.

I'm playing with a solution now. I'll email a proposal shortly.

g.




