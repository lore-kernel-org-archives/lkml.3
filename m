Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3AOEM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:12:26 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:55913 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3AOEMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:12:25 -0500
Message-ID: <1358223166.27472.3.camel@gitbox>
Subject: Re: [Bulk] [PATCH] timer: vt8500: Move timer code to
 drivers/clocksource
From: Tony Prisk <linux@prisktech.co.nz>
To: Olof Johansson <olof@lixom.net>
Cc: VT8500 Mailing List <vt8500-wm8505-linux-kernel@googlegroups.com>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 15 Jan 2013 17:12:46 +1300
In-Reply-To: <20130114200743.GA26482@quad.lixom.net>
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
	 <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
	 <1358140429.25452.1.camel@gitbox> <1358142455.25591.1.camel@gitbox>
	 <20130114200743.GA26482@quad.lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 12:07 -0800, Olof Johansson wrote:
> On Mon, Jan 14, 2013 at 06:47:35PM +1300, Tony Prisk wrote:
> > On Mon, 2013-01-14 at 18:13 +1300, Tony Prisk wrote:
> > > On Mon, 2013-01-14 at 18:09 +1300, Tony Prisk wrote:
> > > > This patch moves arch-vt8500/timer.c into drivers/clocksource and
> > > > updates the necessary Kconfig/Makefile options.
> > > > 
> > > > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> > > > ---
> > > >  arch/arm/mach-vt8500/Kconfig       |    1 +
> > > >  arch/arm/mach-vt8500/Makefile      |    2 +-
> > > >  arch/arm/mach-vt8500/common.h      |    1 -
> > > >  arch/arm/mach-vt8500/timer.c       |  184 ------------------------------------
> > > >  arch/arm/mach-vt8500/vt8500.c      |    1 +
> > > >  drivers/clocksource/Kconfig        |    3 +
> > > >  drivers/clocksource/Makefile       |    1 +
> > > >  drivers/clocksource/vt8500_timer.c |  184 ++++++++++++++++++++++++++++++++++++
> > > >  include/linux/vt8500_timer.h       |   22 +++++
> > > >  9 files changed, 213 insertions(+), 186 deletions(-)
> > > >  delete mode 100644 arch/arm/mach-vt8500/timer.c
> > > >  create mode 100644 drivers/clocksource/vt8500_timer.c
> > > >  create mode 100644 include/linux/vt8500_timer.h
> > > 
> > > Darn.. forgot the -m again. I'll await your feedback regarding the
> > > basing of the patch first (and any other feedback), then I'll redo it
> > > with the correct stats.
> > > 
> > > Regards
> > > Tony P
> > 
> > Oh grr.. forget this completely. It doesn't take into account the
> > patches I already sent for WM8850.
> > 
> > I guess it needs to be based on timer/cleanup + vt8500/wm8x50.
> > 
> > Need a little advise on how to handle this one please :)
> 
> The normal way to handle these kind of dependencies is to base them on merges
> of the needed branches. Based on the later email, you only seem to need
> timer/cleanup, but if you would have needed the other one, then you'd merge
> that on top of timer/cleanup, and then add your patches.
> 
> Of course, ideally you would do the cleanup, then add the wm8x50 features,
> but in reality work doesn't always pan out that way, so you end up with
> cleanups that depend on including new features in the same (sweeping)
> cleanup since they have already been merged. That's when things sometimes
> get hairy, and we need to start a second cleanup branch that's "after"
> the feature branch in the sequence of topics. But it should be rare,
> and in your case it seems like it wasn't needed.
> 
> 
> -Olof
> 

Just to clarify what I did (and to make sure it was as you understood
it):

#1) I wrote the patch on top of timer/cleanup. This is the branch the
patch was written for.

#2) I then pulled timer/cleanup and merged vt8500/wm8x50 on top, then
reapplied the patch from #1 - it applied cleanly.

What I have just realised is that you might?? get a conflict when you
merge vt8500/wm8x50 on top of wherever this patch ends up due to the few
lines at the top of arch-vt8500/Kconfig having changed (the addition of
SELECT VT8500_TIMER). This should be trivial to fix (I assume).

Regards
Tony P

