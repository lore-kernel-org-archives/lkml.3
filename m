Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3KLW6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:58:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:50208 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3KLW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:58:03 -0500
Date: Tue, 12 Nov 2013 23:57:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: 3.12 fixes
In-Reply-To: <20131112183553.GQ14892@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1311122316270.30673@ionos.tec.linutronix.de>
References: <528234B9.7080402@linaro.org> <20131112183553.GQ14892@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-227678707-1384294644=:30673"
Content-ID: <alpine.DEB.2.02.1311122324390.30673@ionos.tec.linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-227678707-1384294644=:30673
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1311122324391.30673@ionos.tec.linutronix.de>

On Tue, 12 Nov 2013, Uwe Kleine-König wrote:
> On Tue, Nov 12, 2013 at 03:01:29PM +0100, Daniel Lezcano wrote:
> > 
> > Hi Ingo and Thomas,
> > 
> > this pull request has the following contain:
> > 
> >  * Laurent Pinchard fixed a missing a clk_put in case the
> > registering of the sh_mtu[2] drivers fails.
> > 
> >  * Uwe Kleine-König reuse clockevents_config_and_register for the
> > at91rm9200_time timer as it was depending on the patch (commit
> > a4578ea (clockevents: Sanitize ticks to nsec conversion).
> > 
> > I don't know why Thomas's patch "clockevents: Sanitize ticks to nsec
> > conversion" appears in the request log because it is not part of the
> > patches interval I specified for git request pull. The diffstat does
> > not show the files which should have been changed by the patch. In
> > any case I kept the changelog untouched since it is what gives me
> > git and maybe someone can tell me why it appears.
> Look at:
> 
> 	git log --oneline --graph --boundary 97b9410..42ab380
> 
> Then you see that there is Thomas' patch twice. Once the version he
> committed and sent to Linus (97b9410) and once the version that you get
> as part of my pull request (a4578ea). To fix this (assuming you don't
> care much about a stable tree), simply do:
> 
> 	git rebase 97b9410 42ab380
> 
> and let the result pull.

The whole misery starts that you decided to play maintainer and grab
some patches from the mailinglist and then offering them via a pull
request to me and others. Finally you tricked Daniel to take them,
which is a different issue.

There is a reason why I ignored that pull request:

 I generally do not pull git trees from people who I'm not
 trusting. And I have good reasons not to trust you at all.

Aside of that, I decided to give you a chance and actually pulled
your tree into a temporary branch and found out that it's missing a
stable annotation. Which made the whole exercise go into /dev/null

Now Linus pulled my version way before Daniel pulled your tree into
his. And you even commented on my commit that I forgot to add a
tested-by tag. Yes, I missed that in favour of the stable annotation.

But instead of rebasing your tree or even just withdrawing it and
resending the at91 patch, you let Daniel pull your thing.

Of course Daniel failed to detect the pointless commit in your pull
request at the point of merging it and then he starts asking questions
when he sends the pull request for his aggregated stuff ....

There is a good reason why most maintainers have a strict policy from
whom they are pulling from and from whom they are just accepting
patches by mail.

Daniel, please provide me a rebased version, but be more careful
versus integration of random pull requests next time.

Thanks,

	tglx


--8323329-227678707-1384294644=:30673--
