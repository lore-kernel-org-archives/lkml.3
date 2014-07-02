Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaGBLef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:34:35 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63108 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaGBLee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:34:34 -0400
Date: Wed, 2 Jul 2014 12:34:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com
Subject: Re: [PATCH v2 4/5] phy: miphy365x: Represent each PHY channel as a
 subnode
Message-ID: <20140702113428.GA16724@lee--X1>
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
 <1404133317-25953-5-git-send-email-lee.jones@linaro.org>
 <20140630144114.GB25926@lee--X1>
 <53B3DE4F.1040100@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B3DE4F.1040100@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 30 June 2014 08:11 PM, Lee Jones wrote:
> > phy: miphy365x: Represent each PHY channel as a DT subnode
> > 
> > This has the added advantages of being able to enable/disable each
> > of the channels as simply as enabling/disabling the DT node.
> > 
> > Suggested-by: Kishon Vijay Abraham I <kishon@ti.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
> > index 1109f42..2c4ea6e 100644
> > --- a/drivers/phy/phy-miphy365x.c
> > +++ b/drivers/phy/phy-miphy365x.c

[...]

> > -static int miphy365x_of_probe(struct device_node *np,
> > +static int miphy365x_of_probe(struct platform_device *pdev,
> >  			      struct miphy365x_dev *phy_dev)
> >  {
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct device_node *child;
> > +	int child_count = 0;
> > +
> > +	for_each_child_of_node(np, child)
> > +		child_count++;
> 
> use of_get_child_count() instead.

Ah, nice. I'll do that.

[...]

> I think you can merge this to your original patch.

I can do that, but I thought It'd be nice to keep some history and
show the migration over to a different setup.  This is particularly
important for when we back-port the changes back into the internal
development kernel.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
