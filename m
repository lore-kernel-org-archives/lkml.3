Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaGPJPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:15:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33182 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715AbaGPJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:15:38 -0400
Date: Wed, 16 Jul 2014 11:15:33 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140716091533.GB28151@kwain>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405499166-6726-8-git-send-email-antoine.tenart@free-electrons.com>
 <42036198.zWkqnus6xa@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42036198.zWkqnus6xa@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Jul 16, 2014 at 10:41:10AM +0200, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 10:26:01 Antoine Ténart wrote:
> > +
> > +       if (priv->dma_mask) {
> > +               ret = dma_coerce_mask_and_coherent(&pdev->dev, priv->dma_mask);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> > 
> 
> As mentioned in my comment for the binding, this is the wrong way to do it.
> Russell has in the past converted all drivers that did this manually to 
> do dma_coerce_mask_and_coherent() so we can spot them more easily, but we
> should really be doing this better for new drivers.
> 
> Can you describe what the restriction is that you want to put on the dma mask?

Some people wanted the possibility to set the DMA mask as this USB2 CI
driver does not do specific Berlin operation and can be reused later.
I don't particularly need to call dma_coerce_mask_and_coherent() in my
case, as far as I know.

They can maybe give the restrictions they might want to put on the DMA
mask.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
