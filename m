Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3BGMX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:23:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:53966 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab3BGMXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:23:54 -0500
Message-ID: <1360239793.2650.28.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Date: Thu, 07 Feb 2013 23:23:13 +1100
In-Reply-To: <1360239636.2650.26.camel@pasglop>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	 <1781360.cmQWHCW5SC@wuerfel>
	 <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
	 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
	 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
	 <1360066756.4529.6.camel@pasglop>
	 <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
	 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
	 <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop>
	 <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
	 <1360186550.2650.4.camel@pasglop> <51139974.2040601@synopsys.com>
	 <1360239636.2650.26.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 23:20 +1100, Benjamin Herrenschmidt wrote:

> For the "swapped" case, I would suggest using ioread16be for the registers
> for the data port, use ioread16_rep followed by a pass of byteswap. I assume
> that this incorrect wiring case only happens on BE platforms right ?

Of course that won't work on writes unless you use a bounce buffer, but
heh, who cares, it's busted anyway ?

Another option is to stick with a loop of ioread16be/iowrite16be, it
*should* work, but it will have too many memory barriers, the impact
will vary depending on the core.

Cheers,
Ben.


