Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaGPKON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:14:13 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:61191 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPKOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:14:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Wed, 16 Jul 2014 12:14:02 +0200
Message-ID: <5615007.cNNjmu3rBK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140716091533.GB28151@kwain>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <42036198.zWkqnus6xa@wuerfel> <20140716091533.GB28151@kwain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:JTZWBkzbW4qT9wInvRjS78jFCW6mC1OO8ZgnMk+KptN
 1RdVsXX62Fw0dU61DhJ1LRIt7jy6KKfPXMc8Yj+AfPWrPcGVKS
 VQJEaHSktuA2s31OnDUr8gBgMCHAsVFBQs0kTAZQgcfXUbdQwW
 QvYmtxq8wmEFrIgEOfO2KbU06s0dVcMGz/HyZzlcILvfNin989
 3rUyKM9OBtUxaaGuG66AnL9G3qusKXIUOVV51k7XCwvWlZ8rDG
 hL7AdGR8MxJMMC+hojrSBd7JfrMLcUwjt616i3qixY7D1atnN7
 0NTPeXVCVLAZHWvgfW8EzujNa5BAcZYWAc23EuPWfIR11FQ/E8
 YPRcdmT478BzvkIlK3tI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 11:15:33 Antoine Ténart wrote:
> 
> On Wed, Jul 16, 2014 at 10:41:10AM +0200, Arnd Bergmann wrote:
> > On Wednesday 16 July 2014 10:26:01 Antoine Ténart wrote:
> > > +
> > > +       if (priv->dma_mask) {
> > > +               ret = dma_coerce_mask_and_coherent(&pdev->dev, priv->dma_mask);
> > > +               if (ret)
> > > +                       return ret;
> > > +       }
> > > +
> > > 
> > 
> > As mentioned in my comment for the binding, this is the wrong way to do it.
> > Russell has in the past converted all drivers that did this manually to 
> > do dma_coerce_mask_and_coherent() so we can spot them more easily, but we
> > should really be doing this better for new drivers.
> > 
> > Can you describe what the restriction is that you want to put on the dma mask?
> 
> Some people wanted the possibility to set the DMA mask as this USB2 CI
> driver does not do specific Berlin operation and can be reused later.
> I don't particularly need to call dma_coerce_mask_and_coherent() in my
> case, as far as I know.

Ok, just remove the call then and rely on the default mask.
 
> They can maybe give the restrictions they might want to put on the DMA
> mask.

If the restriction is from the bus, it should get handled automatically
by the device probe as long as the correct dma-ranges property is there
(though we have a small bug there at the moment). If there is a variation
of ci13xxx that can't do 32-bit DMA, that should use a different compatible
string and pass a fixed mask into dma_set_mask_and_coherent() based on
the device.

	Arnd
