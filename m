Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3BEMVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:21:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:38693 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab3BEMVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:21:16 -0500
Message-ID: <1360066756.4529.6.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Date: Tue, 05 Feb 2013 23:19:16 +1100
In-Reply-To: <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <1781360.cmQWHCW5SC@wuerfel>
	 <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
	 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 11:54 +0100, Michal Simek wrote:
> 
> xilinx ppc is big endian
> xilinx arm is little endian
> xilinx microblaze is little endian and big endian

You are talking about the core, why should the xsysace block driver be
synthesized with the same endianness as the core ? That's not terribly
useful, especially since reverse load/stores on ppc are essentially
free...

> It is just sharing the same IP across all platforms. Which is better
> than create new devices and new device drivers for it. It means that
> all of them are register compatible but require access with native
> platform endianness as I listed above.

Every attempt at doing "native platform endianness" has always been a
misguided attempt turning into a trainwreck (see OHCI USB).

Just pick one endian for the device and stick to it.

> It is not a problem to create runtime wrapper and even detect endian
> directly in the driver
> but the point if this is the proper design.
> Also ioread32 and ioread32be shouldn't be used on ARM because there
> are missing memory barriers.

Then fix them, they shouldn't be, it's a bug, it will break many other
drivers. They should be fully equivalent to readl.

Ben.


