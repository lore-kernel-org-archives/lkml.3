Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaBXA2F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:28:05 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24122 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbaBXA2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:28:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcDAJKRClOl5H4JgWdsb2JhbABZDsRsgSMOAQEWJiiCJQEBBAE6PwULCxgJFRAPAUcGE4d9CMYiF45kB4Q4BKxKf1Mo
From: Alistair Popple <alistair@popple.id.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Tony Prisk <linux@prisktech.co.nz>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 4/7] ECHI Platform: Merge ppc-of EHCI driver into the ehci-platform driver
Date: Mon, 24 Feb 2014 11:28:01 +1100
Message-ID: <2268977.fdRl41kSok@mexican>
User-Agent: KMail/4.9.5 (Linux/3.5.0-45-generic; KDE/4.9.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1402211037300.1273-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1402211037300.1273-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 10:41:50 Alan Stern wrote:
> On Fri, 21 Feb 2014, Alistair Popple wrote:
> > Currently the ppc-of driver uses the compatibility string
> > "usb-ehci". This means platforms that use device-tree and implement an
> > EHCI compatible interface have to either use the ppc-of driver or add
> > a compatible line to the ehci-platform driver. It would be more
> > appropriate for the platform driver to be compatible with "usb-ehci"
> > as non-powerpc platforms are also beginning to utilise device-tree.
> > 
> > This patch merges the device tree property parsing from ehci-ppc-of
> > into the platform driver and adds a "usb-ehci" compatibility
> > string. The existing ehci-ppc-of driver is removed and the 440EPX
> > specific quirks are added to the ehci-platform driver.
> > 
> > Signed-off-by: Alistair Popple <alistair@popple.id.au>
> 
> This patch is also out of date.  The compatibility string used by the
> ehci-platform driver is "generic-ehci".

Ok. I will switch to using "generic-ehci" in the Akebono device tree.

> There remains the question of whether to merge ehci-ppc-of into
> ehci-platform.  This would be a rather invasive change, but I suppose
> we could do it.  With adjustments along the lines suggested by Mark
> Rutland.

As I can use "generic-ehci" to support Akebono I will drop this patch. I can 
look at merging ehci-ppc-of at some later date if desired (thanks Mark & Tony 
for reviewing though).

- Alistair

> Alan Stern
