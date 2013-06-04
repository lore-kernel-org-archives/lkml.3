Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab3FDGtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:49:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34640 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab3FDGtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:49:47 -0400
Date: Tue, 4 Jun 2013 08:49:40 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Hein Tibosch <hein_tibosch@yahoo.es>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, michal.simek@xilinx.com,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH] net/macb: fix ISR clear-on-write behavior only for
 some SoC
Message-ID: <20130604064940.GA5107@pengutronix.de>
References: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com>
 <FE065E51-1EAA-47ED-8C7B-0F2E6418F349@jcrosoft.com>
 <51918C23.7040106@yahoo.es>
 <20130514055256.GD22508@game.jcrosoft.org>
 <51AD8611.8070102@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD8611.8070102@monstr.eu>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:46:43 up 86 days, 16:27, 23 users,  load average: 0.33, 0.32,
 0.23
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 08:15:45AM +0200, Michal Simek wrote:
> On 05/14/2013 07:52 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 08:58 Tue 14 May     , Hein Tibosch wrote:
> >> On 5/14/2013 12:05 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >>> On May 14, 2013, at 12:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> >>>
> >>>> Commit 749a2b6 (net/macb: clear tx/rx completion flags in ISR)
> >>>> introduces clear-on-write on ISR register. This behavior is not always
> >>>> implemented when using Cadence MACB/GEM and is breaking other platforms.
> >>>> We are using a new Device Tree compatibility string and a capability
> >>>> property to actually activate this clear-on-write behavior on ISR.
> >>>>
> >>>> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
> >>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >>> can we detect it via the IP?
> >>
> >> This was my first proposal, have it based on the value of MACB's
> >> register 'MID' (offset 0x00fc, lower 16 bits).
> >> On avr32 it reads: 0x0000010D, on Zynq it reports 0x00000119
> >>
> >> So for the moment, CAPS_ISR_CLEAR_ON_WRITE could be set if the revision
> >> equals to 0x00000119?
> > so no it will not work
> > 
> > as the gem on sama5 is 00020119
> > 
> > so version 0x119 too
> > 
> > nico 
> > Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Was this added to any queue or branch?
> I would like to enable macb for zynq and not sure if "cdns,zynq-7000-gem"
> compatible string goes to mainline.
> 

Hi!

This is already in next, but you can use the default compatible as the
DCR1 is used instead of DT binding.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
