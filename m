Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaKXTpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:45:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48203 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaKXTph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:45:37 -0500
Date: Mon, 24 Nov 2014 20:45:33 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio for bus
 recovery
Message-ID: <20141124194533.GU4431@pengutronix.de>
References: <1416477788-5544-6-git-send-email-grygorii.strashko@ti.com>
 <20141123170400.GC4431@pengutronix.de>
 <54732F8E.4080105@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54732F8E.4080105@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On Mon, Nov 24, 2014 at 03:15:58PM +0200, Grygorii Strashko wrote:
> On 11/23/2014 07:04 PM, Uwe Kleine-König wrote:
> > On Thu, Nov 20, 2014 at 12:03:08PM +0200, Grygorii Strashko wrote:
> >> @@ -664,6 +759,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
> >>   		if (!of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> >>   			&prop))
> >>   			dev->pdata->bus_freq = prop / 1000;
> >> +		dev->pdata->has_pfunc = true;
> > I don't understand this. Why does this ICPFUNC recovery work if the bus
> > is probed by oftree, but doesn't if not?
> 
> I've mentioned this in commit message:
>  Allow platforms to indicate the presence of the ICPFUNC registers with a has_pfunc
>  platform data flag and enable this mode for platforms which supports DT (da850 and
>  Keystone 2 are two SoCs which support DT now and they also support ICPFUNC registers).
Ah, so you assume that in the dt case the pfunc functionality is
available. I didn't understand if it's bad or not if this assumption is
wrong, but I suggest to only use the pfunc stuff if the device node has
a given property (e.g. ti,has_pfunc).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
