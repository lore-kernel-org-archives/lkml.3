Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaEWKDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:03:47 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:54682 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaEWKDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:03:46 -0400
Date: Fri, 23 May 2014 11:03:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com
Subject: Re: [RFC PATCH 1/3] mfd: AXP22x: add support for APX221 PMIC
Message-ID: <20140523100339.GO19747@lee--X1>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
 <1400176305-22737-2-git-send-email-boris.brezillon@free-electrons.com>
 <20140519172817.GE20435@lee--X1>
 <537A4324.4060905@free-electrons.com>
 <537B06A0.3040706@redhat.com>
 <20140520074810.GE20874@lee--X1>
 <537EF4A6.2050405@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537EF4A6.2050405@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> This patch introduces preliminary support for the X-Powers AXP221 PMIC.
> >>>>> The AXP221 is typically used on boards using Allwinner's A31 SoC.
> >>>>>
> >>>>> At the moment, this driver only exposes regulator devices, but other
> >>>>> subdevices.
> >>>>>
> >>>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >>>>> ---
> >>>>>  drivers/mfd/Kconfig        |  12 +++
> >>>>>  drivers/mfd/Makefile       |   1 +
> >>>>>  drivers/mfd/axp22x.c       | 237 +++++++++++++++++++++++++++++++++++++++++++++
> >>>>>  include/linux/mfd/axp22x.h | 149 ++++++++++++++++++++++++++++
> >>>>>  4 files changed, 399 insertions(+)
> >>>>>  create mode 100644 drivers/mfd/axp22x.c
> >>>>>  create mode 100644 include/linux/mfd/axp22x.h
> >>>> Not a chance.
> >>>>
> >>>> Farrrr, too much common code with axp20x.c - please merge into one file.
> >>>>
> >>> This was one of the questions I asked in my cover letter (could you take
> >>> a look at it and tell me what's your prefered solution ?) ;-).
> >>>
> >>> I first tried to reuse the axp20x drivers, but ended up copying almost
> >>> all definitions, hence I decided to first do a different driver and ask
> >>> for advices.
> >> I've just taken a good look at this (I'm planning on doing an axp152 driver
> >> myself), and it seems that using a single mfd driver for the 20x and 221 should
> >> be quite feasible:
> >>
> >> - axp20x.h would get some new register defines for registers which are
> >>   different (or unique) to the 221 prefixed with aXP221
> >> - An axp20x_writeable_ranges would need
> >>   to be extended with a third range going from AXP221_BAT_CAP1 (0xe0)
> >>   to AXP221_BAT_LOW_THRESH (0xe6)
> >> - axp20x_writeable_table would get .n_yes_ranges set to 2, and a new
> >>   apx22x_writeable_table would be introduced with n_yes_ranges set to 3.
> >> - add a new axp221_supplies array
> >> - add a new axp221_cells array
> >> - and finally use the proper structs in axp20x_i2c_probe depending on the type
> >>
> >> Note that this means sharing ie the interrupt table, which is ok since they
> >> are the same, except that the 221 has a couple of interrupts missing, but
> >> the ones which are shared are all at the same place.
> > Exactly.  As .probe() is identical, you only require some device
> > matching and some extra structs where the data actually differs
> > between devices.
> >
> 
> I think you've applied this patch on your for-next tree by mistake.
> As stated above, this driver should be merged with the axp20x one.

You're right, I added it for testing, but removed it soon after.  I've
now re-pushed the branch, so it should be gone now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
