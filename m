Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaIWNgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:36:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57725 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751742AbaIWNgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:36:50 -0400
Date: Tue, 23 Sep 2014 15:36:45 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140923133645.GA18924@kwain>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
 <2909480.SL9c0XWUbW@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2909480.SL9c0XWUbW@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Tue, Sep 23, 2014 at 12:39:04PM +0200, Arnd Bergmann wrote:
> On Tuesday 23 September 2014 12:28:03 Antoine Tenart wrote:
> > +       if (dev->of_node) {
> > +               ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > +               if (ret)
> > +                       goto clk_err;
> > +       } else {
> > +               ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +               if (ret)
> > +                       goto clk_err;
> > +       }
> > 
> 
> Why do you care about the non-DT case here? I think it would be nicer to
> open-code the ci_hdrc_usb2_dt_probe() function in here and remove
> the dma_set_mask_and_coherent(), which should not even be necessary for
> the case where you have a hardwired platform device.
> 

I thought we agreed to call dma_set_mask_and_coherent():
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/273335.html

I do not have a strong opinion on this as I only use the dt case for my
usage.


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
