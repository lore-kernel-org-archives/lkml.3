Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaKXT15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:27:57 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:58220 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752643AbaKXT1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:27:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18YW8cZEOPCGgELQrx1NVVp
Date: Mon, 24 Nov 2014 11:25:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>,
        Alexander Kochetkov <al.kochet@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling
 invalid BB-bit values
Message-ID: <20141124192517.GE2757@atomide.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
 <20141124191023.GG25712@saruman>
 <20141124191347.GA26751@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124191347.GA26751@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wolfram Sang <wsa@the-dreams.de> [141124 11:14]:
> On Mon, Nov 24, 2014 at 01:10:23PM -0600, Felipe Balbi wrote:
> > On Mon, Nov 24, 2014 at 11:08:48AM -0800, Kevin Hilman wrote:
> > > On Sat, Nov 22, 2014 at 11:47 AM, Alexander Kochetkov
> > > <al.kochet@gmail.com> wrote:
> > > > In a multimaster environment, after IP software reset, BB-bit value doesn't
> > > > correspond to the current bus state. It may happen what BB-bit will be 0,
> > > > while the bus is busy due to another I2C master activity.
> > > >
> > > > Any transfer started when BB=0 and bus is busy wouldn't be completed by IP
> > > > and results in controller timeout. More over, in some cases IP could
> > > > interrupt another master's transfer and corrupt data on wire.
> > > >
> > > > The commit implement method allowing to prevent IP from entering into
> > > > "controller timeout" state and from "data corruption" state.
> > > >
> > > > The one drawback is the need to wait for 10ms before the first transfer.
> > > >
> > > > Tested on Beagleboard XM C.
> > > > Tested on BBB and AM437x Starter Kit by Felipe Balbi.
> > > >
> > > > Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> > > > Tested-by: Felipe Balbi <balbi@ti.com>
> > > > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > > 
> > > This patch recently hit linux-next (as commit 903c3859f77f) and boot
> > > breakage[1] in next-20141124 on OMAP3530 Beagle and Overo/Tobi boards
> > > was bisected down to this commit.
> > > 
> > > Kevin
> > > 
> > > [1] http://status.armcloud.us/boot/?next-20141124&omap
> > 
> > btw, based on Kevin's boot test, only OMAP3530 is failing.
> 
> OK, giving Alexander some time for a fix. If it can't be found, I'll
> revert this patch. Thanks!

I can confirm reverting it fixes things for me as well thanks.

Regards,

Tony

