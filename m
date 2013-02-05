Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3BESdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:33:45 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57294 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3BESdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:33:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130205171451.GE17852@n2100.arm.linux.org.uk>
References: <510FF1A6.403@mvista.com>
	<20130204164712.GB4269@arwen.pp.htv.fi>
	<510FF5C9.3030600@mvista.com>
	<20130204170216.GC4269@arwen.pp.htv.fi>
	<51100A72.6030909@ti.com>
	<CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com>
	<20130204203358.GX4720@opensource.wolfsonmicro.com>
	<CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com>
	<51102E25.8040107@ti.com>
	<CACRpkdaUQ60W8Vmg3MpvP5uV+3jD3y4+9V2et4Ni+z-7k=aFTg@mail.gmail.com>
	<20130205171451.GE17852@n2100.arm.linux.org.uk>
Date: Tue, 5 Feb 2013 19:33:42 +0100
Message-ID: <CACRpkdbruBRH8TJb8kkopYEZrpX+h73HT=1VDa=tOWPKg-sGJw@mail.gmail.com>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Cyril Chemparathy <cyril@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, balbi@ti.com,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        "Nair, Sandeep" <sandeep_n@ti.com>, Chris Ball <cjb@laptop.org>,
        Matt Porter <mporter@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 6:14 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 05, 2013 at 04:30:45PM +0100, Linus Walleij wrote:

>> So put them on a wait list? Surely you will have a list of pending
>> cookies and pick from the front of the queue if there isn't a hole on
>> queue position 0.
>
> Not quite.  The key is the cookie system DMA engine employs to indicate
> when a cookie is complete.
>
> Cookies between the "issued sequence" and "completed sequence" are defined
> to be in progress, everything else is defined to be completed.
>
> This means that if "completed sequence" is 1, and "issued sequence" is 5,
> then cookies with values 2, 3, 4, 5 are in progress.  You can't mark
> sequence 4 as being complete until 2 and 3 have completed.

Yes that is true. DMA transfers on a certain channel are defined
as progressing linearly per-cookie. I wonder if that is a problem
in this case though (actually it seems the reverse, this helps
in Cyril's case.)

> If we need out-of-order completion, then that's a problem for the DMA
> engine API, because you'd need to radically change the way "completion"
> is marked.

True. I wonder if this usecase is ever going to be applicable
however. It could maybe be useful in some instances of
memcpy() I could dream up, whereas for device transfers it
seems unlikely to me.

Yours,
Linus Walleij
