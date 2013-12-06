Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3LFJyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:54:11 -0500
Received: from zimbra.real-time.com ([63.170.91.9]:37506 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3LFJyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:54:08 -0500
Date: Fri, 6 Dec 2013 20:53:45 +1100
From: James Cameron <quozl@laptop.org>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Crispin <blogic@openwrt.org>, Jiri Slaby <jslaby@suse.cz>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Zhou Zhu <zzhu3@marvell.com>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131206095345.GQ16425@us.netrek.org>
References: <20131205043544.GA28580@kroah.com>
 <1386286149-2855-1-git-send-email-ynvich@gmail.com>
 <20131206000253.GC21358@kroah.com>
 <20131206001728.GJ4360@n2100.arm.linux.org.uk>
 <1386322131.7152.36.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386322131.7152.36.camel@host5.omatika.ru>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 01:28:51PM +0400, Sergei Ianovich wrote:
> On Fri, 2013-12-06 at 00:17 +0000, Russell King - ARM Linux wrote:
> 
> > I may be able to - one of the downsides though is that many of these
> > systems had hard-coded scripts which started a getty on the original
> > port - and that kind of makes it difficult to sort out.  This kind of
> > change becomes very much one of Linus' "flag days".
> 
> > So I'd suggest that we have a period where the old driver is still
> > available, so at least people can choose to use the old major/minor
> > numbers for a while.
> 
> The patch doesn't change how the driver looks from the outside. The old
> driver was using 8250 name (ttyS), major (4) and first minor (64). So we
> only resolve an internal conflict.

I don't understand why /dev/ttyS2 (4,66) changed to /dev/ttyS0 (4,64)
after the patch was applied to olpc-kernel/arm-3.5 but, as you say it
doesn't change, perhaps there is something between 3.5 and now for me
to watch out for.  My problem.

> Kernel configuration is the place where issues may appear, since the
> patch removes CONFIG_SERIAL_PXA_CONSOLE option. I've updated all
> in-kernel users. However, out-of-kernel configs will no longer provide
> serial console, unless manually reconfigured. Is this the case we should
> worry about?

OLPC holds an out-of-kernel config (xo_4_defconfig); but no, I don't
think we'd have trouble with this.  Go for it.

-- 
James Cameron
http://quozl.linux.org.au/
