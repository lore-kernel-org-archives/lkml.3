Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaG1OD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:03:29 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62836 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaG1OD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:03:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Date: Mon, 28 Jul 2014 16:02:47 +0200
Message-ID: <120751941.rzCjA94qJu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406554444.8530.45.camel@smile.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com> <5712887.nI9VbeNx2r@wuerfel> <1406554444.8530.45.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8IMqlGLXsDLea0Z4Abp3/X8Czu/bozrQoVqZEPgXpGn
 QYxzu/3va/1x+Y6kCwwz3ke4phOy/V2paXQ4pZv8h4l75L5B8w
 gfUMEPZ3XFuT2NRH/yNvjDrnYi3w4tY8YEPgXb2Vb3mO5bXX7i
 5fx83M+J9/GCDY1/winLytqm8nItTVGe+AjhOJRH4e1ghDw4Ut
 NOYxbwSISOBS/euf5MmMZm8qnLb5QoUMfHELDO5+2U/cvdQuOr
 hMRPQJ8HA9iNHg2ZPNGoxlo/yldqEZETb8rg31zxxAUe5qvjc0
 d0RUh+mjyzwFVL1TTpWl7VrYVNp1+ee7qK1/PiUvpZngbcnRhj
 +AIAOTQtZxmU6imDIGS8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 16:34:04 Andy Shevchenko wrote:
> On Mon, 2014-07-28 at 14:47 +0200, Arnd Bergmann wrote:
> > On Monday 28 July 2014 14:06:20 Andy Shevchenko wrote:
> > static bool atmci_filter(struct dma_chan *chan, void *pdata)
> > {
> >         struct mci_platform_data *sl_pdata = pdata;
> >         struct mci_dma_data *sl;
> > 
> >         if (!sl_pdata)
> >                 return false;
> > 
> >         sl = sl_pdata->dma_slave;
> >         if (sl && find_slave_dev(sl) == chan->device->dev) {
> >                 chan->private = slave_data_ptr(sl);
> >                 return true;
> >         } else {
> >                 return false;
> >         }
> > }
> > 
> > It sets the dw_dma_slave information from  slave_data_ptr(sl) here,
> > and does not attempt to set a slave_id at all, the slave_config
> > call only sets the required fields.
> > 
> > Do you still see a problem here?
> 
> Sorry, I was talking about master defaults regarding to your patch that
> proposes to remove that part from dw_dmac. I mean it should be set in
> function mentioned early.

Ok. So atmci_filter is still correct because chan->private contains
a pointer to a structure with both request and master settings, right?

> > c) request line and masters are all configured from avr32/arm32
> >    platform data.
> > d) request line and masters are all configured from Bay Trail
> >    PCI ID (Implemented by Mika's patch)
> 
> Actually here I just recall the case when we might have different number
> of masters and use the same IP block [of SPI controller], how could you
> distinguish that case? How to provide proper masters?
> 
> It's luckily not a problem right now, but still potential one in some
> cases.

Do you mean case d? I think for each PCI ID, you will have to add the
correct settings to some table that is used in the filter function.

Are there any cases you know where we can't hardcode them?

	Arnd
