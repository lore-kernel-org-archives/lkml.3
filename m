Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaBERna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:43:30 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57314 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752964AbaBERn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:43:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+jCRVtGuovP/IUt0welIXB3kO2VkUHhWM=
X-DKIM: OpenDKIM Filter v2.0.1 titan B33E251E6D0
Date: Wed, 5 Feb 2014 12:43:16 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140205174316.GV8533@titan.lakedaemon.net>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140205140802.9977.19747@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205140802.9977.19747@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 06:08:02AM -0800, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2014-01-25 10:19:06)
> > This patch set fixes clk init order that went upside-down with
> > v3.14. I haven't really investigated what caused this, but I assume
> > it is related with DT node reordering by addresses.
> > 
> > Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
> > registered before core clocks driver. Unfortunately, we cannot
> > return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
> > init order for our drivers is always core clocks before clock gating,
> > we maintain init order ourselves by hooking CLK_OF_DECLARE to one
> > init function that will register core clocks before clock gating
> > driver.
> > 
> > This patch is based on pre-v3.14-rc1 mainline and should go in as
> > fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
> > I suggest Jason picks it up as a topic branch.
> 
> Sebastian,
> 
> These patches look OK to me. I'd rather take Gregory Clement's "respect
> the clock dependencies in of_clk_init" patch towards 3.15, so this fix
> will still be necessary for the current -rc's.
> 
> Jason, will you be sending a PR?

Ahh, just saw this now.  ignore my previous comments about using
Gregory's series as the fix.

Sure, I'll put this together for a pr to the clk tree.

thx,

Jason.

> > The patches have been boot tested on Dove and compile-tested only
> > for Kirkwood, Armada 370 and XP.
> > 
> > Sebastian Hesselbarth (4):
> >   clk: mvebu: armada-370: maintain clock init order
> >   clk: mvebu: armada-xp: maintain clock init order
> >   clk: mvebu: dove: maintain clock init order
> >   clk: mvebu: kirkwood: maintain clock init order
> > 
> >  drivers/clk/mvebu/armada-370.c | 21 ++++++++++-----------
> >  drivers/clk/mvebu/armada-xp.c  | 20 +++++++++-----------
> >  drivers/clk/mvebu/dove.c       | 19 +++++++++----------
> >  drivers/clk/mvebu/kirkwood.c   | 34 ++++++++++++++++------------------
> >  4 files changed, 44 insertions(+), 50 deletions(-)
> > 
> > ---
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Gregory Clement <gregory.clement@free-electrons.com>
> > Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > -- 
> > 1.8.5.2
> > 
