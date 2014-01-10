Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaAJO0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:26:53 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:45798 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaAJO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:26:49 -0500
Date: Fri, 10 Jan 2014 14:26:40 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Roger Quadros <rogerq@ti.com>, bcousson@baylibre.com, tony@atomide.com,
        balbi@ti.com, sre@debian.org, mark.rutland@arm.com,
        m.paolino@virtualopensystems.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 2/9] mfd: omap-usb-host: Get clocks based on hardware
 revision
Message-ID: <20140110142640.GA32035@lee--X1>
References: <1389269303-30465-1-git-send-email-rogerq@ti.com>
 <1389269303-30465-3-git-send-email-rogerq@ti.com>
 <20140110102251.GH28141@lee--X1>
 <201401101513.40470.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201401101513.40470.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Arnd Bergmann wrote:

> On Friday 10 January 2014, Lee Jones wrote:
> > >  
> > > -     need_logic_fck = false;
> > > +     /* Set all clocks as invalid to begin with */
> > > +     omap->ehci_logic_fck = omap->init_60m_fclk = ERR_PTR(-EINVAL);
> > > +     omap->utmi_p1_gfclk = omap->utmi_p2_gfclk = ERR_PTR(-EINVAL);
> > > +     omap->xclk60mhsp1_ck = omap->xclk60mhsp2_ck = ERR_PTR(-EINVAL);
> > 
> > I don't think this is the correct error code.
> > 
> > -EINVAL means 'invalid parameter'.
> > 
> > You probably want -ENODEV or -ENOSYS ('function not implemented'
> > probably isn't ideal either tbh, but you get the idea). Perhaps you
> > can set them as NULL and check for IS_ERR_OR_NULL() instead?
> 
> I think ENODEV is ok here, I'd much prefer this over IS_ERR_OR_NULL().

Sounds good to me.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
