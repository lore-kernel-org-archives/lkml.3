Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3HMJ77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:59:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34890 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3HMJ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:59:58 -0400
Date: Tue, 13 Aug 2013 11:59:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130813095941.GB30913@pengutronix.de>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130813080956.GE9316@ulmo>
 <20130813103030.1e4156a1@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813103030.1e4156a1@skate>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:58:38 up 13 days, 19:02, 31 users,  load average: 0.07, 0.08,
 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 10:30:30AM +0200, Thomas Petazzoni wrote:
> Dear Thierry Reding,
> 
> On Tue, 13 Aug 2013 10:09:56 +0200, Thierry Reding wrote:
> 
> > > +- reset-gpios: optional gpio to PERST#
> > > +- reset-delay-ms: delay in ms to wait after reset de-assertion
> > 
> > I remember some recent discussion about this, and we now have this reset
> > framework, so perhaps it makes more sense to use the reset binding for
> > this? Cc'ing Stephen (as part of the device tree bindings maintainers
> > team) who was involved in that recent reset bindings discussion.
> 
> I also thought about this, but the reset framework seems to be designed
> for "reset controller" IPs, i.e special IPs that are controlling reset
> signals. Looking at Documentation/devicetree/bindings/reset/reset.txt,
> I'm not sure to see how this would apply to GPIO-controlled reset
> signals.

Search for:

[PATCH v10] reset: Add driver for gpio-controlled reset pins

Which aims to be a solution for what you need here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
