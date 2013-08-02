Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3HBT5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:57:35 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38756 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3HBT5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:57:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130802075352.GY7656@atomide.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20130731073802.GT7656@atomide.com> <20130731123351.GA30474@kroah.com>
 <20130802075352.GY7656@atomide.com>
Message-ID: <20130802195730.6450.84988@quantum>
User-Agent: alot/0.3.4
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat and how
 to avoid it
Date: Fri, 02 Aug 2013 12:57:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tony Lindgren (2013-08-02 00:53:53)
> People are unnecessarily defining registers in kernel for similar devices
> over and over again for each new SoC at the arch level and now more and
> more at the driver level.
> 
> One example of that are device tree based drivers that don't describe
> the actual hardware, but instead have a binding that points to an index
> of defined registers in the driver.

Apologies for possibly hijacking this thread, but this issue keeps me up
at night. People use DT for different things and have different ideas
about its Purpose In The World.

Tony wants to move data out of the kernel, which was the impetus behind
the OMAP DT clock patches that describes every single clock in a DT node
(around 250 clocks). This create very large dts, but reduces the clock
drivers to pure logic, no data.

Other folks are motivated only to get rid of board files and platform
data hacks. They keep all of the clock data in the clock driver and
instead use DT only as a way to hook up clocks to devices via a simple
mapping, thus describing how individual boards or SoC variants are set
up outside of the kernel source. dts remains small, essentially just an
array to map bindings but all of the clock data remains in the kernel.

Both approaches have their merits and drawbacks. Is it possible to
gather consensus on selecting a single approach? For the clock subsystem
I've accepted drivers and DT bindings which do either. I simply do not
have the DT experience or sensibilities to draw a line in the sand...
and maybe I should not draw a line in the sand and just let people pick
whichever approach they prefer (which maintains the status quo).

If the ARM Summit figures out all the answers then please let me know
what they are :-)

Thanks,
Mike
