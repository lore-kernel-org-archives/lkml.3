Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaKSNoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:44:16 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:41196 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaKSNoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:44:14 -0500
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2014 08:44:14 EST
Date: Wed, 19 Nov 2014 15:35:32 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Du, Wenkai" <wenkai.du@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] i2c: designware: prevent early stop on TX FIFO empty
Message-ID: <20141119133531.GD2374@sapphire.tkos.co.il>
References: <545CB6C4.8010201@arm.com>
 <20141119092122.GC1439@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119092122.GC1439@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Wed, Nov 19, 2014 at 10:21:22AM +0100, Wolfram Sang wrote:
> On Fri, Nov 07, 2014 at 12:10:44PM +0000, Andrew Jackson wrote:
> > If the Designware core is configured with IC_EMPTYFIFO_HOLD_MASTER_EN
> > set to zero, allowing the TX FIFO to become empty causes a STOP
> > condition to be generated on the I2C bus. If the transmit FIFO
> > threshold is set too high, an erroneous STOP condition can be
> > generated on long transfers - particularly where the interrupt
> > latency is extended.
> > 
> > Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> So, what do other designware users think of this change (nice CC list
> BTW, Andrew). Adding Mika, too.

I don't have access to this hardware anymore so I can't test. As far as I 
remember the spec this change should be OK.

baruch

> >  drivers/i2c/busses/i2c-designware-core.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> > index 3c20e4b..e070edd 100644
> > --- a/drivers/i2c/busses/i2c-designware-core.c
> > +++ b/drivers/i2c/busses/i2c-designware-core.c
> > @@ -363,7 +363,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
> >  	}
> >  
> >  	/* Configure Tx/Rx FIFO threshold levels */
> > -	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
> > +	dw_writel(dev, dev->tx_fifo_depth / 2, DW_IC_TX_TL);
> >  	dw_writel(dev, 0, DW_IC_RX_TL);
> >  
> >  	/* configure the i2c master */

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
