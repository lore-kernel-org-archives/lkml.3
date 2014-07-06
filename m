Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaGGJyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:54:18 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55121 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGJyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:54:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v10 2/2] dmaengine: sun6i: Add driver for the Allwinner A31 DMA controller
Date: Sun, 6 Jul 2014 17:22:00 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com> <20140701124852.GB6064@leverpostej> <20140704075710.GN31996@lukather>
In-Reply-To: <20140704075710.GN31996@lukather>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201407061722.01279.arnd@arndb.de>
X-Provags-ID: V02:K0:O82IxIpedRAx95D7vkqa6cvR6JxEBKGfgpainHBujnr
 UquNUe35hxO3HqHoipOZynbeu/wK4ObTaj1rMI4Lp0I6vkOP/O
 mUMgjA9B1t7kgQn8cx0ocgr4BD5WSj43GSNhfkclg1QCj8Ehzs
 ONKmiTuRl1xoHqorpvVAzcE7z2YxYxyhmI9Nsg5HTZxnYsSXo4
 nU+dH7ysC24bEriBFZfYR35n0Lb+kDiB7OdjYntvhIy+1Adixi
 mrym+qqwQMbhVlqYpIQz3+W/imtda30gzF0NGpwsFXPJ+Y1Av7
 4mj1qIFIkYpiLvWcrbCXlgTKQ5YBW36618Qxl1MfsXfgZTsFrQ
 8bVGB94UYxBSAkLdP0XmhCgLlCXVPEpKK9zB7L3gL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014, Maxime Ripard wrote:
> > > > It feels a little fragile to rely on the organisation of the clock tree
> > > > and the naming thereof. If the IP block is ever reused on an SoC with a
> > > > different clock tree layout then we have to handle things differently.
> > > 
> > > What do you suggest then?
> > 
> > I will admit that I don't have a better suggestion.
> > 
> > Without knowing which particular constraint on the mux parent clock we
> > care about it's difficult to suggest anything useful.
> 
> Well, I first made it into the mach- directory, and then was told to
> move it in the driver itself, so we're kind of running out of options
> :)

How about having a property in the clock provider node that forces a
specific value for the mux? I think that's generally the preferred solution
for any clock settings that go beyond what an OS can be expected to figure
out for itself.

	Arnd
