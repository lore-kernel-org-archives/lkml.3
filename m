Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaHURVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:21:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13738 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752001AbaHURVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:21:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bRx6K0z3ECgVf6moVrcZq
Date: Thu, 21 Aug 2014 10:21:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] usb: phy: twl4030-usb: Fix regressions to runtime PM on
 omaps
Message-ID: <20140821172108.GC10066@atomide.com>
References: <20140821164346.GA10066@atomide.com>
 <20140821170615.GG11146@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821170615.GG11146@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140821 10:09]:
> On Thu, Aug 21, 2014 at 09:43:46AM -0700, Tony Lindgren wrote:
> > @@ -744,6 +778,9 @@ static int twl4030_usb_probe(struct platform_device *pdev)
> >  		return status;
> >  	}
> >  
> > +	pm_runtime_mark_last_busy(&pdev->dev);
> > +	pm_runtime_put(&pdev->dev);
> 
> don't you wanna do a put_autosuspend() here instead ?

Sure yeah makes sense as the twl4030_phy_init() usually
runs shortly after.
 
> Other than that
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Thanks,

Tony
