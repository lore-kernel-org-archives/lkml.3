Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040AbaIJFbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 01:31:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:36532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaIJFbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 01:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,496,1406617200"; 
   d="scan'208";a="570958629"
Date: Wed, 10 Sep 2014 08:30:56 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mike Turquette <mturquette@linaro.org>, tomeu.vizoso@collabora.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH 1/2] acpi: lpss: convert from struct clk to struct
 clk_core
Message-ID: <20140910053056.GA30423@xps8300>
References: <1410242868-14750-1-git-send-email-mturquette@linaro.org>
 <1410242868-14750-2-git-send-email-mturquette@linaro.org>
 <7263163.khRHYpcBRO@vostro.rjw.lan>
 <20140909135209.GW13406@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909135209.GW13406@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 04:52:09PM +0300, Mika Westerberg wrote:
> On Tue, Sep 09, 2014 at 03:16:29PM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 08, 2014 11:07:47 PM Mike Turquette wrote:
> > > Looks like this driver was missed during the original mass driver
> > > rework[0]. This patch converts the LPSS driver to the new clock provider
> > > data type (struct clk_core).
> > > 
> > > If there are no objections I propose to roll this patch into a rebase of
> > > that patch[0] in my tree.
> > > 
> > > [0] http://lkml.kernel.org/r/<1409758317-20564-1-git-send-email-tomeu.vizoso@collabora.com>
> > > 
> > > Signed-off-by: Mike Turquette <mturquette@linaro.org>
> > 
> > Mika, any comments here?
> 
> Adding Heikki who recently did some clock changes to acpi_lpss.c.
> 
> To me this looks fine.

Looks fine to me to.

> > > ---
> > >  drivers/acpi/acpi_lpss.c               | 6 +++---
> > >  include/linux/platform_data/clk-lpss.h | 2 +-
> > >  2 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> > > index 9dfec48..454179f 100644
> > > --- a/drivers/acpi/acpi_lpss.c
> > > +++ b/drivers/acpi/acpi_lpss.c
> > > @@ -57,7 +57,7 @@ ACPI_MODULE_NAME("acpi_lpss");
> > >  struct lpss_shared_clock {
> > >  	const char *name;
> > >  	unsigned long rate;
> > > -	struct clk *clk;
> > > +	struct clk_core *clk;
> > >  };
> > >  
> > >  struct lpss_private_data;
> > > @@ -83,7 +83,7 @@ static struct lpss_device_desc lpss_dma_desc = {
> > >  struct lpss_private_data {
> > >  	void __iomem *mmio_base;
> > >  	resource_size_t mmio_size;
> > > -	struct clk *clk;
> > > +	struct clk_core *clk;
> > >  	const struct lpss_device_desc *dev_desc;
> > >  	u32 prv_reg_ctx[LPSS_PRV_REG_COUNT];
> > >  };
> > > @@ -278,7 +278,7 @@ static int register_device_clock(struct acpi_device *adev,
> > >  	const struct lpss_device_desc *dev_desc = pdata->dev_desc;
> > >  	struct lpss_shared_clock *shared_clock = dev_desc->shared_clock;
> > >  	const char *devname = dev_name(&adev->dev);
> > > -	struct clk *clk = ERR_PTR(-ENODEV);
> > > +	struct clk_core *clk = ERR_PTR(-ENODEV);
> > >  	struct lpss_clk_data *clk_data;
> > >  	const char *parent, *clk_name;
> > >  	void __iomem *prv_base;
> > > diff --git a/include/linux/platform_data/clk-lpss.h b/include/linux/platform_data/clk-lpss.h
> > > index 2390199..3c3237c 100644
> > > --- a/include/linux/platform_data/clk-lpss.h
> > > +++ b/include/linux/platform_data/clk-lpss.h
> > > @@ -15,7 +15,7 @@
> > >  
> > >  struct lpss_clk_data {
> > >  	const char *name;
> > > -	struct clk *clk;
> > > +	struct clk_core *clk;
> > >  };
> > >  
> > >  extern int lpt_clk_init(void);
> > > 
> > 
> > -- 
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.

-- 
heikki
