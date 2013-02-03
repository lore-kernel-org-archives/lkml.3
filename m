Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3BCRCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:02:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:64717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3BCRCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:02:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="282235271"
Date: Sun, 3 Feb 2013 18:02:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Kennet Wallden <kennet.wallden@stericsson.com>
Subject: Re: [PATCH 06/26] mfd: ab8500-sysctrl: Provide configuration for
 SysClkReqRfClkBuf registers
Message-ID: <20130203170204.GP8476@sortiz-mobl>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
 <1358254566-12419-7-git-send-email-lee.jones@linaro.org>
 <20130127235248.GN1174@sortiz-mobl>
 <20130128083816.GZ15873@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128083816.GZ15873@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Mon, Jan 28, 2013 at 08:38:16AM +0000, Lee Jones wrote:
> On Mon, 28 Jan 2013, Samuel Ortiz wrote:
> 
> > Hi Lee, Kennet,
> > 
> > On Tue, Jan 15, 2013 at 12:55:46PM +0000, Lee Jones wrote:
> > > From: Kennet Wallden <kennet.wallden@stericsson.com>
> > > 
> > > Add the possibility to pass configuration settings for
> > > SysCl1kReqRfClkBuf to SysClk8ReqRfClkBuf via platform data.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > Signed-off-by: Kennet Wallden <kennet.wallden@stericsson.com>
> > > Reviewed-by: Karl-Johan PERNTZ <karl-johan.perntz@stericsson.com>
> > > Reviewed-by: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
> > > ---
> > >  drivers/mfd/ab8500-sysctrl.c              |   25 +++++++++++++++++++++++++
> > >  include/linux/mfd/abx500/ab8500-sysctrl.h |    5 +++++
> > >  include/linux/mfd/abx500/ab8500.h         |    2 ++
> > >  3 files changed, 32 insertions(+)
> > > 
> > > diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
> > > index cf58f69..19a024e 100644
> > > --- a/drivers/mfd/ab8500-sysctrl.c
> > > +++ b/drivers/mfd/ab8500-sysctrl.c
> > > @@ -113,11 +113,36 @@ int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value)
> > >  static int __devinit ab8500_sysctrl_probe(struct platform_device *pdev)
> > >  {
> > >  	struct ab8500_platform_data *plat;
> > > +	struct ab8500_sysctrl_platform_data *pdata;
> > >  
> > >  	sysctrl_dev = &pdev->dev;
> > >  	plat = dev_get_platdata(pdev->dev.parent);
> > >  	if (plat->pm_power_off)
> > >  		pm_power_off = ab8500_power_off;
> > > +
> > > +	pdata = plat->sysctrl;
> > > +
> > > +	if (pdata) {
> > > +		int ret;
> > > +		int i;
> > > +		int j;
> > Cosmetic 
> > int i, j, ret;
> 
> Hmmm... this is how I'd prefer it too, 
Great, I'm glad we agree :)

> but other maintainers prefer
> one-per-line. It would be better if we could standardise it somewhere
> to prevent unnecessary fixups.
I certainly don't like that coding style and I sincerely believe a vast
majority of the kernel code avoids it as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
