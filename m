Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaBFSJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:09:06 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51421 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaBFSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:09:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+OccRWbWahwKph9oS+l6QOoEWtJPEmXU=
X-DKIM: OpenDKIM Filter v2.0.1 titan B3BC951FA06
Date: Thu, 6 Feb 2014 13:08:52 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140206180852.GK8533@titan.lakedaemon.net>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140205183457.GW8533@titan.lakedaemon.net>
 <20140206170838.GB12542@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206170838.GB12542@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 02:08:39PM -0300, Ezequiel Garcia wrote:
> On Wed, Feb 05, 2014 at 01:34:57PM -0500, Jason Cooper wrote:
> > On Sat, Jan 25, 2014 at 07:19:06PM +0100, Sebastian Hesselbarth wrote:
> > > This patch set fixes clk init order that went upside-down with
> > > v3.14. I haven't really investigated what caused this, but I assume
> > > it is related with DT node reordering by addresses.
> > > 
> > > Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
> > > registered before core clocks driver. Unfortunately, we cannot
> > > return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
> > > init order for our drivers is always core clocks before clock gating,
> > > we maintain init order ourselves by hooking CLK_OF_DECLARE to one
> > > init function that will register core clocks before clock gating
> > > driver.
> > > 
> > > This patch is based on pre-v3.14-rc1 mainline and should go in as
> > > fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
> > > I suggest Jason picks it up as a topic branch.
> > > 
> > > The patches have been boot tested on Dove and compile-tested only
> > > for Kirkwood, Armada 370 and XP.
> > > 
> > > Sebastian Hesselbarth (4):
> > >   clk: mvebu: armada-370: maintain clock init order
> > >   clk: mvebu: armada-xp: maintain clock init order
> > >   clk: mvebu: dove: maintain clock init order
> > >   clk: mvebu: kirkwood: maintain clock init order
> > > 
> > >  drivers/clk/mvebu/armada-370.c | 21 ++++++++++-----------
> > >  drivers/clk/mvebu/armada-xp.c  | 20 +++++++++-----------
> > >  drivers/clk/mvebu/dove.c       | 19 +++++++++----------
> > >  drivers/clk/mvebu/kirkwood.c   | 34 ++++++++++++++++------------------
> > >  4 files changed, 44 insertions(+), 50 deletions(-)
> > 
> > Whole series applied to mvebu/clk-fixes.
> > 
> 
> FWIW, Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> Observed "division by zero" get fixed by this, on A370 Mirabox, Kirkwood
> Topkick and Dove Cubox.

Added for patches 1, 3, and 4 (all but armada-xp.c)  Thanks for testing.

thx,

Jason.
