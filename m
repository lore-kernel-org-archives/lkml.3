Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaKQO4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:56:22 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34554 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbaKQO4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:56:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/FvdZrjh3OOBuQyultr8Ff
Date: Mon, 17 Nov 2014 06:55:46 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, bcousson@baylibre.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sakari.ailus@iki.fi, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141117145545.GC7046@atomide.com>
References: <20141116075928.GA9763@amd>
 <201411170943.20810@pali>
 <20141117100519.GA4353@amd>
 <201411171109.47795@pali>
 <20141117101553.GA21151@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141117101553.GA21151@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [141117 02:17]:
> On Mon 2014-11-17 11:09:45, Pali Rohár wrote:
> > On Monday 17 November 2014 11:05:19 Pavel Machek wrote:
> > > Hi!
> > > 
> > > On Mon 2014-11-17 09:43:19, Pali Rohár wrote:
> > > > On Sunday 16 November 2014 08:59:28 Pavel Machek wrote:
> > > > > For device tree people: Yes, I know I'll have to create
> > > > > file in documentation, but does the binding below look
> > > > > acceptable?
> > > > > 
> > > > > I'll clean up driver code a bit more, remove the printks.
> > > > > Anything else obviously wrong?
> > > > 
> > > > I think that this patch is probably not good and specially
> > > > not for n900. adp1653 should be registered throw omap3 isp
> > > > camera subsystem which does not have DT support yet.
> > > 
> > > Can you explain?
> > > 
> > > adp1653 is independend device on i2c bus, and we have kernel
> > > driver for it (unlike rest of n900 camera system). Just now
> > > it is unusable due to lack of DT binding. It has two
> > > functions, LED light and a camera flash; yes, the second one
> > > should be integrated to the rest of camera system, but that
> > > is not yet merged. That should not prevent us from merging DT
> > > support for the flash, so that this part can be
> > > tested/maintained.
> > > 
> > 
> > Ok. When ISP camera subsystem has DT support somebody will modify 
> > n900 DT to add camera flash from adp1653 to ISP... I believe it 
> > will not be hard.
> 
> Exactly. And yes, I'd like to get complete camera support for n900
> merged. But first step is "make sure existing support does not break".

There's nothing stopping us from initializing the camera code from
pdata-quirks.c for now to keep it working. Certainly the binding
should be added to the driver, but that removes a dependency to
the legacy booting mode if things are otherwise working.

Regards,

Tony
