Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3KTTOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 14:14:02 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:33942 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754803Ab3KTTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 14:13:59 -0500
Date: Wed, 20 Nov 2013 21:13:30 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20131120191328.GA30494@chokladfabriken.org>
References: <1384920820-18740-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <000701cee5b8$9b61e3b0$d225ab10$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000701cee5b8$9b61e3b0$d225ab10$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 03:20:28PM +0900, Jingoo Han wrote:
> On Wednesday, November 20, 2013 1:14 PM, Stefan Kristiansson wrote:
> 
> > +static int ocfb_probe(struct platform_device *pdev)
> > +{
> > +	int ret = 0;
> > +	struct ocfb_dev *fbdev;
> > +	struct ocfb_par *par = &ocfb_par_priv;
> > +	struct resource *res;
> > +	struct resource *mmio;
> > +	int fbsize;
> > +
> > +	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
> 
> Please use devm_kzalloc() instead of kzalloc().
> In this case, kfree() can be removed from ocfb_probe()
> and ocfb_remove(). Thus, it will make the code smaller.
> 

Nice, thanks for the hint!
Consider it done.

> [.....]
> 
> > +
> > +#ifdef MODULE
> 
> I don't think that '#ifdef MODULE' is necessary.
> Is there any reason?
> 

You're right, that's not necessary, I'll remove that.

Thanks alot for taking the time to review it!

Stefan
