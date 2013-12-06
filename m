Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3LFARu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:17:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44015 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3LFARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:17:48 -0500
Date: Fri, 6 Dec 2013 00:17:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Zhou Zhu <zzhu3@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131206001728.GJ4360@n2100.arm.linux.org.uk>
References: <20131205043544.GA28580@kroah.com> <1386286149-2855-1-git-send-email-ynvich@gmail.com> <20131206000253.GC21358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206000253.GC21358@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 04:02:53PM -0800, Greg Kroah-Hartman wrote:
> On Fri, Dec 06, 2013 at 03:28:37AM +0400, Sergei Ianovich wrote:
> > pxa2xx-uart was a separate uart platform driver. It was declaring
> > the same device names and numbers as 8250 driver. As a result,
> > it was impossible to use 8250 driver on PXA SoCs.
> > 
> > Upon closer examination pxa2xx-uart turned out to be a clone of
> > 8250_core driver.
> > 
> > Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> > CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Wonderful!
> 
> Can someone else test this to verify it works for them on their platform
> as well?

I may be able to - one of the downsides though is that many of these
systems had hard-coded scripts which started a getty on the original
port - and that kind of makes it difficult to sort out.  This kind of
change becomes very much one of Linus' "flag days".

So I'd suggest that we have a period where the old driver is still
available, so at least people can choose to use the old major/minor
numbers for a while.
