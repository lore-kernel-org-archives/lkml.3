Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3EVGIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:08:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:36775 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab3EVGI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:08:29 -0400
Message-ID: <1369202788.3870.3.camel@pasglop>
Subject: Re: [PATCH] bestcomm: no need to free when kzalloc fail
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: vinod.koul@intel.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Libo Chen <libo.chen@huawei.com>, agust@denx.de, phdm@macqel.be,
        Li Zefan <lizefan@huawei.com>
Date: Wed, 22 May 2013 16:06:28 +1000
In-Reply-To: <519C4E4D.1060101@huawei.com>
References: <1367743104-3448-1-git-send-email-libo.chen@huawei.com>
	 <519C4E4D.1060101@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 12:49 +0800, Libo Chen wrote:
> ping...

This is pointless. We routinely avoid adding such crap by having
the various free(...) routines cope with NULL. You just need to make
sure you are indeed NULL in the error case.

Ben.

> On 2013/5/5 16:38, chenlibo.3@gmail.com wrote:
> > From: Libo Chen <libo.chen@huawei.com>
> > 
> > There is no need to free bcom_eng if kzalloc fail
> > 
> > Signed-off-by: Libo Chen <libo.chen@huawei.com>
> > ---
> >  drivers/dma/bestcomm/bestcomm.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dma/bestcomm/bestcomm.c b/drivers/dma/bestcomm/bestcomm.c
> > index a8c2e29..300ee2d 100644
> > --- a/drivers/dma/bestcomm/bestcomm.c
> > +++ b/drivers/dma/bestcomm/bestcomm.c
> > @@ -400,7 +400,7 @@ static int mpc52xx_bcom_probe(struct platform_device *op)
> >  		printk(KERN_ERR DRIVER_NAME ": "
> >  			"Can't allocate state structure\n");
> >  		rv = -ENOMEM;
> > -		goto error_sramclean;
> > +		goto error_kzalloc;
> >  	}
> >  
> >  	/* Save the node */
> > @@ -449,6 +449,7 @@ error_release:
> >  	release_mem_region(res_bcom.start, sizeof(struct mpc52xx_sdma));
> >  error_sramclean:
> >  	kfree(bcom_eng);
> > +error_kzalloc:
> >  	bcom_sram_cleanup();
> >  error_ofput:
> >  	of_node_put(op->dev.of_node);
> > 
> 


