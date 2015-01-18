Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbbARLSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:18:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53692 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbbARLSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:18:18 -0500
Date: Sun, 18 Jan 2015 12:17:59 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Arend van Spriel <arend@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <mporter@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/3] i2c: iproc: Add Broadcom iProc I2C Driver
Message-ID: <20150118111759.GG22880@pengutronix.de>
References: <rjui@broadcom.com>
 <1421451737-7107-1-git-send-email-rjui@broadcom.com>
 <1421451737-7107-3-git-send-email-rjui@broadcom.com>
 <54BB795C.6040402@broadcom.com>
 <20150118094741.GE22880@pengutronix.de>
 <20150118110658.GA1113@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150118110658.GA1113@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On Sun, Jan 18, 2015 at 12:06:58PM +0100, Wolfram Sang wrote:
> On Sun, Jan 18, 2015 at 10:47:41AM +0100, Uwe Kleine-König wrote:
> > On Sun, Jan 18, 2015 at 10:14:04AM +0100, Arend van Spriel wrote:
> > > On 01/17/15 00:42, Ray Jui wrote:
> > > >+	complete_all(&iproc_i2c->done);
> > > 
> > > Looking over this code it seems to me there is always a single
> > > process waiting for iproc_i2c->done to complete. So using complete()
> > > here would suffice.
> > Yeah, there is always only a single thread waiting. That means both
> > complete and complete_all are suitable. AFAIK there is no reason to pick
> > one over the other in this case.
> 
> Clarity?
And which do you consider more clear? complete_all might result in the
question: "Is there >1 waiter?" and complete might yield to "What about
the other waiters?". If you already know there is only one, both are on
par on clarity. Might only be me?! I don't care much.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
