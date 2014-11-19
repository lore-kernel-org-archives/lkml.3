Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaKSCcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:32:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:34109 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaKSCck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:32:40 -0500
Message-ID: <1416364351.5704.22.camel@kernel.crashing.org>
Subject: Re: [PATCH] of/address: Don't throw errors on absent ranges
 properties
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Nov 2014 13:32:31 +1100
In-Reply-To: <20141118165739.7382AC40966@trevor.secretlab.ca>
References: <1415948303.666.50.camel@kernel.crashing.org>
	 <20141118165739.7382AC40966@trevor.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 16:57 +0000, Grant Likely wrote:
> On Fri, 14 Nov 2014 17:58:23 +1100
> , Benjamin Herrenschmidt <benh@kernel.crashing.org>
>  wrote:
> > The core always tries to translate any "reg" property to construct the platform
> > device names. This results in a pile of "OF: no ranges; cannot translate" errors
> > in dmesg whenever we expose things like i2c devices that cannot directly translate
> > to the MMIO space.
> 
> I don't have a problem with the change, but it seems to be catching an
> odd usage of of_device_make_bus_id(). Why is of_device_make_bus_id()
> being called on i2c devices? Those shouldn't be modelled as
> platform_devices.

Sorry, this was my explanation being full of crap. It's my i2c
_controller_ which is a platform device, and is on the xscom bus which
isn't directly MMIO translatable.

The patch still stands :)

Cheers,
Ben.

> g.
> 
> > 
> > Turn this into a pr_debug instead
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > index f0541fd..bf1f79d 100644
> > --- a/drivers/of/address.c
> > +++ b/drivers/of/address.c
> > @@ -444,7 +444,7 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
> >  	 */
> >  	ranges = of_get_property(parent, rprop, &rlen);
> >  	if (ranges == NULL && !of_empty_ranges_quirk()) {
> > -		pr_err("OF: no ranges; cannot translate\n");
> > +		pr_debug("OF: no ranges; cannot translate\n");
> >  		return 1;
> >  	}
> >  	if (ranges == NULL || rlen == 0) {
> > 
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


