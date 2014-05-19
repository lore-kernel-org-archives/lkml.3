Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaESJL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:11:29 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:52996 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaESJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:11:27 -0400
Date: Mon, 19 May 2014 10:11:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Brown <broonie@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] mfd-core: Don't register supplies from add_device,
 add register_supply_aliases()
Message-ID: <20140519091121.GA4978@lee--X1>
References: <1400420953-20705-1-git-send-email-hdegoede@redhat.com>
 <1400420953-20705-2-git-send-email-hdegoede@redhat.com>
 <20140519074705.GE2339@lee--X1>
 <20140519074855.GP25203@opensource.wolfsonmicro.com>
 <5379BE43.7090809@redhat.com>
 <20140519082849.GQ25203@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140519082849.GQ25203@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>> We cannot register supply alias in mfd_add_device before calling
> > >>> platform_add_device, for 2 reasons:
> > >>> 1) devm resources may not be registered before the (platform) drivers probe
> > >>>    method runs
> > >>> 2) The platform-dev's name must be set before registering the aliases which
> > >>>    happens from platform_add_device.
> > >>>
> > >>> So stop registering supply aliases from mfd_add_device, and add a
> > >>> mfd_register_supply_aliases helper functions for the cell's plaform driver
> > >>> probe method to use.
> > >>>
> > >>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > >>> ---
> > >>>  drivers/mfd/mfd-core.c   | 37 +++++++++++++++++++++----------------
> > >>>  include/linux/mfd/core.h |  6 +++++-
> > >>>  2 files changed, 26 insertions(+), 17 deletions(-)
> > >>
> > >> Change looks reasonable to me, but I'd like to have Mark look over the
> > >> changes.  If he's okay with them I think it's best for this set to go
> > >> through the MFD tree as a whole.
> > > 
> > > This should already be fixed by this patch:
> > > 
> > > mfd: core: Don't use devres functions before device is added
> > 
> > Ah, I did not check next, yes that would fix *half* of the problem,
> > the other half is that adding aliases uses dev->name (at least for
> > logging, did not check if it is used for anything else) and that is
> > not set yet before the device is added.
> > 
> > Basically the moral of the story is that it is a BAD idea to do
> > anything with a device before it is added. So my proposed series
> > would replace the "mfd: core: Don't use devres functions before device is added"
> > patch.
> 
> Cool cool, since my patch doesn't seem to have made it in anyway
> I guess lets proceed with your series then.

The patch is applied locally, but the branch isn't pushed.  I'll
replace that patch with this set - once Mark provides his feedback.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
