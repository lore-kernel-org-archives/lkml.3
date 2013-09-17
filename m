Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3IQXod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:44:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:26741 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3IQXoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:44:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ou4p6YnbBb93sBM+oanEX
Date: Tue, 17 Sep 2013 16:44:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Suman Anna <s-anna@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] mailbox: remove unnecessary platform_set_drvdata()
Message-ID: <20130917234424.GP9994@atomide.com>
References: <002201ce9edc$cdc3fb90$694bf2b0$%han@samsung.com>
 <52178FAD.7040402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52178FAD.7040402@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suman Anna <s-anna@ti.com> [130823 09:50]:
> + OMAP mailing list
> 
> Tony,
> Can you pick up this minor cleanup patch?
> 
> regards
> Suman
> 
> On 08/21/2013 09:10 PM, Jingoo Han wrote:
> > The driver core clears the driver data to NULL after device_release
> > or on probe failure. Thus, it is not needed to manually clear the
> > device driver data to NULL.
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Suman Anna <s-anna@ti.com>

OK applying into omap-for-v3.12/fixes thanks.

Regards,

Tony
 
> > ---
> >  drivers/mailbox/mailbox-omap2.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
> > index eba380d..42d2b89 100644
> > --- a/drivers/mailbox/mailbox-omap2.c
> > +++ b/drivers/mailbox/mailbox-omap2.c
> > @@ -325,7 +325,6 @@ static int omap2_mbox_remove(struct platform_device *pdev)
> >  	kfree(privblk);
> >  	kfree(mboxblk);
> >  	kfree(list);
> > -	platform_set_drvdata(pdev, NULL);
> >  
> >  	return 0;
> >  }
> > 
> 
