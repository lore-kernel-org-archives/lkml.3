Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3JAL3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:29:14 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:46563 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3JAL3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:29:12 -0400
Message-ID: <1380626960.4318.6.camel@porter.coelho.fi>
Subject: Re: using mmc2 on panda [was: Regression 3.11-rc1: omap4panda: no
 usb and consequently no ethernet]
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 01 Oct 2013 14:29:20 +0300
In-Reply-To: <524AA9C1.2000303@broadcom.com>
References: <51E7AA24.6080600@broadcom.com>
	 <20130718085951.GT7656@atomide.com> <51E916C0.8080206@broadcom.com>
	 <51E919CA.8060805@ti.com> <51E91B80.1050609@broadcom.com>
	 <524A823F.6070209@broadcom.com> <524A9AB8.4010407@ti.com>
	 <524A9BB2.2050503@ti.com> <524AA9C1.2000303@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-10-01 at 12:53 +0200, Arend van Spriel wrote:
> On 10/01/2013 11:53 AM, Roger Quadros wrote:
> > On 10/01/2013 12:49 PM, Roger Quadros wrote:
> >> Hi Arend,
> >>
> >> On 10/01/2013 11:05 AM, Arend van Spriel wrote:
> >>> On 07/19/2013 12:57 PM, Arend van Spriel wrote:
> >>>> On 07/19/2013 12:49 PM, Roger Quadros wrote:
> >>>>> On 07/19/2013 01:36 PM, Arend van Spriel wrote:
> >>>>>> On 07/18/2013 10:59 AM, Tony Lindgren wrote:
> >>>>>>> Then for the SDIO with device tree, take a look at the following
> >>>>>>> patches:
> >>>>>>>
> >>>>>>> [PATCH 0/3] WLAN support for omap4 when booted with devicetree
> >>>>>>> http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#
> >>>>>>
> >>>>>> I have been looking at the pandaboard patch in the series above and I
> >>>>>> do have a question. Among other things the patch adds these dt entries.
> >>>>>>
> >>>>>> +            0x108 0x118    /* sdmmc5_clk.sdmmc5_clk INPUT_PULLUP |
> >>>>>> MODE0 */
> >>>>>> +            0x10a 0x118    /* sdmmc5_cmd.sdmmc5_cmd INPUT_PULLUP |
> >>>>>> MODE0 */
> >>>>>>
> >>>>>> If I look at the similar names in the deceased board-omap4panda.c:
> >>>>>>
> >>>>>> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 |
> >>>>>> OMAP_PIN_INPUT_PULLUP),
> >>>>>> board-omap4panda.c:    OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 |
> >>>>>> OMAP_PIN_INPUT_PULLUP),
> >>>>>>
> >>>>>> and in mux44xx.h:
> >>>>>>
> >>>>>> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CLK_OFFSET    0x0148
> >>>>>> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CMD_OFFSET    0x014a
> >>>>>>
> >>>>>> So how did 0x0148 get 0x0108 in DT and 0x014a get 0x010a. There is
> >>>>>> probably an explanation to it and it would help my understanding to
> >>>>>> know where this difference comes from. Hope you can help me out here.
> >>>>>>
> >>>>>
> >>>>> If you see omap4.dtsi, omap4_pmx_core starts at register address
> >>>>> 0x4a100040.
> >>>>>
> >>>>> So, you need to subtract 0x40 from the offsets defined in mux44xx.h
> >>>>> for pmx_core registers.
> >>>>
> >>>> That was what I was looking for. Thanks!
> >>>
> >>> Hi Roger,
> >>>
> >>> It has been a while, but I would like to pickup this thread. We have a couple of pandaboards used as test setup. These have an SDIO adapter hooked up to expansion connector A using MMC2. I have attached the patch file (just ignore platform_data stuff). Now on one board it works, but not for the other. I suspect a board issue so listing the two types that we use:
> >>>
> >>> PandaBoard rev A2 (dmesg: OMAP4430 ES2.1): works
> >>> PandaBoardES rev B1 (dmesg: OMAP4460 ES1.1): nope
> >>>
> >>> Any hints for me.
> >>
> >> Does your PandaboardES have the WLAN chip (U4) mounted? If yes, how do you isolate
> >> it from your external SDIO adapter?
> 
> On my 4460 board in front of me U4 is not populated, but U3 is (the TiWi 
> thing).
> 
> >
> > OK, just realized that the expansion connector uses different pads for MMC2. However, you still
> > need to make sure that the other pins (connected to on board WLAN chip) are not muxed as MMC2.
> 
> I think Luciano added DT patches for on-board WLAN and it uses MMC5 if I 
> am not mistaken(?). Attached are the dmesg logs of the two boards.

I sent 2 patch series to add DT support for the on-board WLAN, but they
were not applied, since there were some comments that required changes.
I really don't have the time to revisit them now that I'm not with TI
anymore, so I'm hoping someone else will pick them up at some point.

FWIW, my patches were working with PandaBoardES rev B1, which was also
OMAP4460 ES1.1.  It worked fine for me, *except* that sometimes for some
unknown reason the SDIO MMC connected to WiLink didn't get probed (as it
appears to be the case on your dmesg-4460.txt).

Most weirdly, it seems that booting the board with a non-DT kernel and
then booting back to the DT kernel seemed to help and the problem was
gone for many reboots, until it happened again.  I never figure out why
this was happening, though. :(

--
Cheers,
Luca.

