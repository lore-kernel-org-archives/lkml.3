Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaFMNRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:17:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48058 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbaFMNR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:17:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OxUpcNn2QCq91ba2KE2pu86KnduJok9Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan 498FF58EC3E
Date: Fri, 13 Jun 2014 09:17:20 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 16/19] irqchip: crossbar: introduce
 ti,max-crossbar-sources to identify valid crossbar mapping
Message-ID: <20140613131720.GI8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-17-git-send-email-r.sricharan@ti.com>
 <20140612135453.GB8664@titan.lakedaemon.net>
 <539AD87C.8000004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AD87C.8000004@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:24:52PM +0530, Sricharan R wrote:
> On Thursday 12 June 2014 07:24 PM, Jason Cooper wrote:
> > On Thu, Jun 12, 2014 at 05:23:24PM +0530, Sricharan R wrote:
...
> >> +	of_property_read_u32(node, "ti,max-crossbar-sources",
> >> +			     &cb->max_crossbar_sources);
> >> +	if (!cb->max_crossbar_sources) {
> >> +		pr_err("missing 'ti,max-crossbar-sources' property\n");
> >> +		ret = -EINVAL;
> >> +		goto err_base;
> >> +	}
> > 
> > This completely breaks all boards using old dtbs.  Please set
> > max_crossbar_sources to a sane value (400) when the property is missing.
> > 
> >> +
> >>  	of_property_read_u32(node, "ti,max-irqs", &max);
> >>  	if (!max) {
> >>  		pr_err("missing 'ti,max-irqs' property\n");
> > 
> > I know this is context, but you may want to look at this property as
> > well and set it to a sane value instead of erroring out.
> > 
>  crossbar dts node itself is not there in any dts yet. So this is not applicable
>  for any old boards. Any future dts with crossbar node should have this property
>  defined.

Now that I see the dra7.dtsi changes, I fully agree.

thx,

Jason.
