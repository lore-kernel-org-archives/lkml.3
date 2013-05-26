Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3EZJfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:35:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47427 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3EZJfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:35:08 -0400
Date: Sun, 26 May 2013 11:35:03 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130526093503.GH17847@lukather>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
 <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
 <51969EA9.1060602@free-electrons.com>
 <5197B82F.8010809@schinagl.nl>
 <519FE0AE.2010102@schinagl.nl>
 <20130525122208.GD17847@lukather>
 <51A1103F.6000702@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A1103F.6000702@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 09:25:51PM +0200, Oliver Schinagl wrote:
> On 05/25/13 14:22, Maxime Ripard wrote:
> >What about:
> >
> >val = ioread32be(base + (key / 4));
> >val >>= (key % 4) * 8;
> >return val & 0xff;
> >
> >No lookup table, no weird swich statement, and you get the endianness
> >conversion only when you need it.
> Ok I think I like the Endianess, ioread32be does the right thing
> then? I'll read up on that.
> As for key / 4; how will that work without the lut?
> 
> Lets take byte 14 (out of the available 16). Byte 14 (0x0e) is
> located in SID_KEY3, so base + 0x0c. We need to write a whole 32bit
> word to keep with alignment, the registers go wakko if you do
> unaligned reads. So we need to read the entire 32 bits, then find
> our byte.
> 
> key / 4 for 14 yields 0x03. So we have base + 0x03, which is not
> what we want. We want base + 0x0c, which is either ((key >> 2) <<
> 2)) Or, ((key / 4) * 4)) which to me, are both equally confusing.

The statement you make that 3 isn't the index you want depends on your
pointer type so it might be what you want, or might not.

If it's still not what you want, you can always use round_down(key, 4).

> So we either use the look up table, which is a little cleaner and is a
> bit more future proof if either a) there's more 'eeprom like'
> storage which can be combined herein or b) 'a' next version has
> non-continuing regions. Granted neither is something to worry about
> right now.

I don't see how it's cleaner (you have three indirections to get
the value that is actually used) or future proof (you have to extend
this lookup table every time you have a slightly larger size).

So I'm sorry but this lookup table holding only the index times 4 is
a non-sense, could we please stop arguing about this?

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
