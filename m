Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaKXUH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:07:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaKXUH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:07:56 -0500
Date: Mon, 24 Nov 2014 21:07:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [4/5] i2c: davinci: use bus recovery infrastructure
Message-ID: <20141124200754.GW4431@pengutronix.de>
References: <1416477788-5544-5-git-send-email-grygorii.strashko@ti.com>
 <20141121190744.GB4431@pengutronix.de>
 <546F9382.40102@ti.com>
 <20141123203634.GG4431@pengutronix.de>
 <547331F2.3000006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547331F2.3000006@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On Mon, Nov 24, 2014 at 03:26:10PM +0200, Grygorii Strashko wrote:
> On 11/23/2014 10:36 PM, Uwe Kleine-König wrote:
> > On Fri, Nov 21, 2014 at 09:33:22PM +0200, Grygorii Strashko wrote:
> >> On 11/21/2014 09:07 PM, Uwe Kleine-König wrote:
> >>> On Thu, Nov 20, 2014 at 12:03:07PM +0200, Grygorii Strashko wrote:
> >>> Just another general comment about the driver that doesn't influence the
> >>> correctness of this patch: The i2c-davinci driver is quite quick to
> >>> reset the bus. I wonder how often this reset triggers. Is the bus in
> >>> question less "stable" than others?
> >>
> >> In comparison to ..? :)
> > In comparison to other bus drivers in other SoCs. I know this might be
> > hard to answer. I just wonder where the reason for this has to be
> > located. Strange hardware? Software bug? Or is this SoC just operating
> > with strange slaves more often than others?
> 
> Davinci driver does reset in two cases:
> - when I2C transaction isn't completed due to timeout (no irq received)
> - when BB is detected
> both cases are reasonable, because in 1st case HW state is undefined
> in 2d case - Davinci I2C supports only master mode and if BB detected
> we need perform some recovery procedure.
note that for multi-master scenarios bus recovery might be bad. So that
has not necessarily something to do with "master mode only".

> Also, this patch doesn't introduce functional changes - it's just code
> reworking intended to reuse I2C bus recovery infrastructure
Yeah this is fine, and my concern shouldn't stop your patch from getting
in as it is an improvement for sure. Still I only had to handle BB once
in my linux lifetime, and that was for a different reason. (Machine
doing massive i2c transfers and so a client was often holding the bus
busy when the watchdog resetted the cpu.) So I just wondered how often
the need for recovery arises.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
