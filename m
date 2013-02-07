Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab3BGVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:09:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:58606 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab3BGVJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:09:56 -0500
Message-ID: <1360271357.2650.34.camel@pasglop>
Subject: Re: [PATCH] drivers/block/xsysace - replace
 in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Date: Fri, 08 Feb 2013 08:09:17 +1100
In-Reply-To: <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
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
	 <1360186550.2650.4.camel@pasglop>
	 <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com>
	 <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com>
	 <5113C459.8000602@synopsys.com>
	 <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 15:23 +0000, Grant Likely wrote:
> 
> Maybe. In a separate patch. Hmmm... I guess there isn't an
> ioread16be_rep variant. 

Because it would not make sense. The ioread16_rep isn't "LE" ... it
should be usable for any kind if data port since such a fifo should
never require byteswap as long as the bus is wired properly (whether the
device is LE or BE).

The problem we have here is that we have an LE device that can be wired
backward. The fact that this only happens when the CPU is BE is somewhat
irrelevant (well, let's say that the confusion is easier to make for the
HW guys when using a BE CPU but fundamentally it's not relevant, a
similar backard wiring could have been done for a BE device on a LE CPU
for example). 

So in that case, you need some kind of hand made loop.

> Oh well. Check first with Michal on LE microblaze before making the
> change. If it doesn't work for him the more understanding is needed. I
> was pretty sure the LE variant already worked.
> 
> > not sure about items for "ace_datain/out_be16" - what about _rep
> options
> > here?
> 
> ioread16_rep should be fine. The ace_data{in,out}_be16 routines need
> to use the LE accessor. The existing code is definitely correct in
> this respect.

Ben.


