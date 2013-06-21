Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423245Ab3FUGpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:45:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51492 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161442Ab3FUGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:45:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18L5YJH/bz2xJIjHwscEZNL
Date: Thu, 20 Jun 2013 23:45:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
Message-ID: <20130621064526.GJ5523@atomide.com>
References: <20130621160800.64f9965229e5042a7b77e212@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130621160800.64f9965229e5042a7b77e212@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [130620 23:14]:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap2/devices.c between commit 4a1c0e83bb4e ("ARM: OMAP2+:
> mbox: remove dependencies with soc.h") from the mailbox tree and commit
> 82c5cde1c4b0 ("ARM: OMAP2+: Remove omap4 ocp2scp pdata") from the arm-soc
> tree.
> 
> I fixed it up (removing the include of
> linux/platform_data/omap_ocp2scp.h) and can carry the fix as necessary
> (no action is required).

Thanks, that's the right fix as that header won't be needed any longer
as we've made omap4 device tree only.
 
> That mailbox tree commit looks very similar to commit b8a7cf8e2b15 ("ARM:
> OMAP2+: mbox: remove dependencies with soc.h") from the arm-soc tree ...

The earlier mailbox branch was merged into arm-soc for a few weeks until
we decided to drop it as Jassi is working on a more generic API. That was
merged in commit 51b5f893, then reverted in commit b5c85186. The updated
mailbox branch accounts for the generic API coming up from Jassi.

Suman, can you please check if Linux next has mailbox related files merged
correctly?
 
> As an aside, the include of linux/usb/omap_control_usb.h into this file
> was removed by commit 608d19380c67 ("ARM: OMAP2+: Remove omap4 pdata for
> USB") in the arm-soc tree, but reintroduced by commit 435f4c6d5242
> ("Merge branch 'next/drivers' into for-next").

Yes omap_control_usb.h is no longer needed either.

Thanks,

Tony
