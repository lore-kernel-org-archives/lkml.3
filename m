Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbbARL5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:57:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59712 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbARL5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:57:08 -0500
Date: Sun, 18 Jan 2015 12:56:51 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Scott Branden <sbranden@broadcom.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ray Jui <rjui@broadcom.com>,
        Christian Daudt <bcm@fixthebug.org>, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-i2c@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150118115650.GH22880@pengutronix.de>
References: <rjui@broadcom.com>
 <1421451737-7107-1-git-send-email-rjui@broadcom.com>
 <1421451737-7107-3-git-send-email-rjui@broadcom.com>
 <54BB795C.6040402@broadcom.com>
 <20150118094741.GE22880@pengutronix.de>
 <20150118110658.GA1113@katana>
 <20150118111759.GG22880@pengutronix.de>
 <54BB9D2B.20408@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BB9D2B.20408@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 18, 2015 at 12:46:51PM +0100, Arend van Spriel wrote:
> On 01/18/15 12:17, Uwe Kleine-König wrote:
> >Hello Wolfram,
> >
> >On Sun, Jan 18, 2015 at 12:06:58PM +0100, Wolfram Sang wrote:
> >>On Sun, Jan 18, 2015 at 10:47:41AM +0100, Uwe Kleine-König wrote:
> >>>On Sun, Jan 18, 2015 at 10:14:04AM +0100, Arend van Spriel wrote:
> >>>>On 01/17/15 00:42, Ray Jui wrote:
> >>>>>+	complete_all(&iproc_i2c->done);
> >>>>
> >>>>Looking over this code it seems to me there is always a single
> >>>>process waiting for iproc_i2c->done to complete. So using complete()
> >>>>here would suffice.
> >>>Yeah, there is always only a single thread waiting. That means both
> >>>complete and complete_all are suitable. AFAIK there is no reason to pick
> >>>one over the other in this case.
> >>
> >>Clarity?
> >And which do you consider more clear? complete_all might result in the
> >question: "Is there>1 waiter?" and complete might yield to "What about
> >the other waiters?". If you already know there is only one, both are on
> >par on clarity. Might only be me?! I don't care much.
> 
> Maybe it is me, but it is not about questions but it is about
> implicit statements that the code makes (or reader derives from it).
> When using complete_all you indicate to the reader "there can be
> more than one waiter". When using complete it indicates "there is
> only one waiter". If those statements are not true that is a code
No, complete works just fine in the presence of >1 waiter. It just wakes
a single waiter and all others continue to wait.
That is, for single-waiter situations there is no semantic difference
between complete and complete_all. But there is a difference for
multi-waiter queues.

I think this is just a matter of your POV in the single-waiter
situation: complete might be intuitive because you just completed a
single task and complete_all might be intuitive because it signals
"I'm completely done, there is noone waiting for me any more.".

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
