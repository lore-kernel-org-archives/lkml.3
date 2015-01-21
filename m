Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbbAUMts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:49:48 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44000 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbAUMtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:49:39 -0500
Date: Wed, 21 Jan 2015 12:49:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 00/13] mtd: st_spi_fsm: Align with ST's internal
 development
Message-ID: <20150121124930.GA22024@x1>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
 <20150113051452.GR9759@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150113051452.GR9759@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Brian Norris wrote:
> On Mon, Dec 15, 2014 at 11:59:07AM +0000, Lee Jones wrote:
> > Hi Brian, all,
> >  
> >  [x] Bulid test
> >  [x] Bisectable
> >  [x] Smatch
> >  [x] Sparse
> 
> Picked patches 1, 2, and 5 to l2-mtd.git. I requested changes to patch 3
> and possibly 4. The rest look OK, but I don't want to futz with patch
> conflicts on the remaining. Please rebase to l2-mtd.git if/when you
> resend.

Sure.  I'll get on to that now.

> > v3:
> >   Further aligned with upstream changes as suggested by Peter Griffin.
> >   The clk_ignore_unused kernel command line parameter is due to be turned
> >   off on STiH4* platforms, so we no longer give the driver the chance to
> >   opt-out of fetching the EMI clock.  We also now provide syscfg offsets
> >   inside the driver, as it's simpler and reduces the cost of having lots
> >   of extra DT properties.
> 
> Typically "simpler" and "reducing the cost of having lots of extra DT
> properties" aren't good enough reasons for immediately breaking an
> existing DT binding. We usually expect to support both for some period
> of time.

Only once a binding has became ABI.  As there are no users of this
driver yet (this will change after this sync'ing patch-set has been
applied), so we can safely consider this binding to be in-progress and
as such, not yet ABI, thus we can do this ol' switch-aroo without the
usual 6 month deprecation period.

> > v2:
> >   These are the last remaining patches in the set, all rebased and
> >   with the DT documentation requested after the last submission.
> >  
> > v1:
> >   This patch-set updates ST's FSM SPI-NOR driver with all the internal
> >   goodness which has happened since the initial (now upstreamed) snapshot
> >   was taken. It covers just over 6 months worth of internal development
> >   and bug-fixes. A final whitespace clean-up is also appended to the set
> >   - to make it look pretty and stuff. :)
> > 
> > Angus Clark (3):
> >   mtd: st_spi_fsm: Add support for N25Q512 and N25Q00A devices
> >   mtd: st_spi_fsm: Update Spansion device entries
> >   mtd: st_spi_fsm: Improve busy wait handling
> > 
> > Lee Jones (9):
> >   mtd: st_spi_fsm: Extend fsm_clear_fifo to handle unwanted bytes
> >   mtd: st_spi_fsm: Obtain and use EMI clock
> >   mtd: st_spi_fsm: dt-bindings: Deprecate generic compatible string
> >   mtd: st_spi_fsm: Fetch boot device locations from DT match tables
> >   mtd: st_spi_fsm: Fix [-Wsign-compare] build warning
> >   mtd: st_spi_fsm: Update the JEDEC probe to handle extended READIDs
> >   mtd: st_spi_fsm: General tidy-up
> >   ARM: STi: stih416: Use new platform specific compatible string
> >   ARM: STi: stih416: Supply EMI clock reference to FSM SPI NOR
> > 
> > Nunzio Raciti (1):
> >   mtd: st_spi_fsm: Add support for Micron N25Q512A
> > 
> >  Documentation/devicetree/bindings/mtd/st-fsm.txt |  20 +-
> >  arch/arm/boot/dts/stih416.dtsi                   |   6 +-
> >  drivers/mtd/devices/st_spi_fsm.c                 | 747 +++++++++++++++--------
> >  include/dt-bindings/clock/stih416-clks.h         |   1 +
> >  4 files changed, 519 insertions(+), 255 deletions(-)
> > 
> 
> Brian

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
