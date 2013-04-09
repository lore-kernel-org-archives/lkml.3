Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937039Ab3DIJf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:35:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892Ab3DIJfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:35:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] ARM: ux500: Move DMA40 platform data includes file out to include/
Date: Tue, 9 Apr 2013 11:35:11 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365434591-21569-1-git-send-email-lee.jones@linaro.org> <201304081817.42031.arnd@arndb.de> <20130409070558.GG3084@gmail.com>
In-Reply-To: <20130409070558.GG3084@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091135.11427.arnd@arndb.de>
X-Provags-ID: V02:K0:/6642Lf40G82z/LkAHEkg0s7mYOo4qz5v+65f5ftXc3
 R1mz/BW9lfBDOaQ1HnlQHkpWk5kbXh48K2udOQMUZCs/1uQm2P
 7Xht5uOYs3U9sgCoCldNZ9/riJxw/n3NFXvp4S7kEGKsxRsiD4
 9VTavD0V/Dsuc1rzevXYNCMM0SV6fRhH4/KzO1hybEnERc8hDX
 c/0D2EghMpWAezrZTHrQSl8mJL6hvO+shRHJdgerHi8AfT0OHs
 uoKIuqeJ+01apl27LqpZs5SI1GlMGHIwLARSqjEN/r1UlTcDt2
 D26CpQLW0NYIF6q0TiIFH98y7FftJrwOMvecj+nDKlbsbytBQc
 TtVWXa2QcwhoBTiX4nlw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> On Mon, 08 Apr 2013, Arnd Bergmann wrote:
> 
> > On Monday 08 April 2013, Lee Jones wrote:
> > > The pin names for DB8500 based platforms need to be moved out of
> > > ux500 platform data and into the new proper location in include/
> > > linux/platform_data/. This way we an reference them from other
> > > external locations, such as the main DMA50 driver(s).
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Hmm, not sure about this one. The slave numbers are not really platform_data
> > and I think they should not be exposed to drivers. It makes sense to
> > keep the numbers for the memcpy channels in the driver itself as they
> > are hardwired in the driver, but the slave channels should stay in the
> > platform I think.
> 
> Just looking at this again now. So you're right in that the main
> reason for moving these out of platform code and into the system-wide
> platform data area is for the memcpy channels. However, I'd prefer to
> keep the channel allocation enum fully contiguous rather than
> splitting them out.
> 
> The channels are only exposed to the one external driver which
> includes them, and that's the D40 driver.
> 
> How against this move are you?

I think it's a move in the wrong direction. If you think we should keep the
knowledge of which channels are used for memcpy outside of the driver,
I would prefer you to drop the the first two patches, which implies that
we will eventually pass that information using DT properties in order get
rid of the auxdata.

	Arnd
