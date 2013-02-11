Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3BKSwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:52:37 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36453 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759594Ab3BKSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:52:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+uPGL6UxvGkD61bZoKpHDc
Date: Mon, 11 Feb 2013 10:52:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Paul Walmsley <paul@pwsan.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mfd tree
Message-ID: <20130211185221.GR4801@atomide.com>
References: <20130211170616.73fd9fd30bb10c27a698ad4d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211170616.73fd9fd30bb10c27a698ad4d@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [130210 22:11]:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap2/usb-host.c between commit 8a89e93237e1 ("mfd:
> omap-usb-host: Consolidate OMAP USB-HS platform data") from the mfd tree
> and commit c1d1cd597fc7 ("ARM: OMAP2+: omap_device: remove obsolete
> pm_lats and early_device code") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks again.

Samuel, up to you, but I suggest you just drop these patches for
now if still possible unless other patches are based on these.

All OMAP USB people, doing these things should be pretty trivial,
just follow these steps:

1. Do all the platform data and header changes first so we can
   put them into a shared minimal topic branch either in the
   USB tree or arm-soc tree

2. Modify the USB driver(s) based on #1 and have them merged into
   the USB tree

3. Add new arch/arm related pdata and .dts entries based on #1
   so we can merge it via arm-soc tree

4. Remove all the old crap later on to avoid extra dependencies
   between these branches

Regards,

Tony
