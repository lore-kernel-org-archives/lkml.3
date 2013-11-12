Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3KLSgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:36:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45606 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3KLSgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:36:00 -0500
Date: Tue, 12 Nov 2013 19:35:53 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource: 3.12 fixes
Message-ID: <20131112183553.GQ14892@pengutronix.de>
References: <528234B9.7080402@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <528234B9.7080402@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 12, 2013 at 03:01:29PM +0100, Daniel Lezcano wrote:
> 
> Hi Ingo and Thomas,
> 
> this pull request has the following contain:
> 
>  * Laurent Pinchard fixed a missing a clk_put in case the
> registering of the sh_mtu[2] drivers fails.
> 
>  * Uwe Kleine-König reuse clockevents_config_and_register for the
> at91rm9200_time timer as it was depending on the patch (commit
> a4578ea (clockevents: Sanitize ticks to nsec conversion).
> 
> I don't know why Thomas's patch "clockevents: Sanitize ticks to nsec
> conversion" appears in the request log because it is not part of the
> patches interval I specified for git request pull. The diffstat does
> not show the files which should have been changed by the patch. In
> any case I kept the changelog untouched since it is what gives me
> git and maybe someone can tell me why it appears.
Look at:

	git log --oneline --graph --boundary 97b9410..42ab380

Then you see that there is Thomas' patch twice. Once the version he
committed and sent to Linus (97b9410) and once the version that you get
as part of my pull request (a4578ea). To fix this (assuming you don't
care much about a stable tree), simply do:

	git rebase 97b9410 42ab380

and let the result pull.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
