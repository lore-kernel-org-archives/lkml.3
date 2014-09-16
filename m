Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaIPNjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:39:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46281 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753259AbaIPNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:39:12 -0400
Date: Tue, 16 Sep 2014 15:38:41 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140916133841.GA4869@kwain>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410777378-12726-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140916005129.GC3379@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140916005129.GC3379@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:51:30AM +0800, Peter Chen wrote:
> On Mon, Sep 15, 2014 at 12:36:13PM +0200, Antoine Tenart wrote:
> > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> > and DMA mask, to support USB2 ChipIdea controllers that don't need
> > specific functions.
> > 
> > Tested on the Marvell Berlin SoCs USB controllers.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > ---
> >  drivers/usb/chipidea/Makefile       |   1 +
> >  drivers/usb/chipidea/ci_hdrc_usb2.c | 137 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 138 insertions(+)
> >  create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
> > 
> 
> compile error:
> 
> /home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c: In function 'ci_hdrc_usb2_dt_probe':
> /home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c:30:2: error: implicit declaration of function 'of_phy_get' [-Werror=implicit-function-declaration]
> /home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c:30:16: warning: assignment makes pointer from integer without a cast [enabled by default]

Did you apply the series introducing the support for the generic PHY
framework in the USB subsystem first? One of the patches includes
'linux/phy/phy.h' in 'linux/usb/otg.h'. That's why I did not encounter
this error.

Anyway, you're right and 'linux/phy/phy.h' should be explicitly included
here.


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
