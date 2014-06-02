Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaFBPob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:44:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59661 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751933AbaFBPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:44:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18x3+f5p78rxN5VDwyq2V6M
Date: Mon, 2 Jun 2014 08:44:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Emil Goode'" <emilgoode@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Trilok Soni'" <tsoni@codeaurora.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [PATCH v2] mfd: fix unintentional NULL check in
 menelaus_set_voltage()
Message-ID: <20140602154421.GB11004@atomide.com>
References: <1401295431-23833-1-git-send-email-emilgoode@gmail.com>
 <000d01cf7adf$9528f9e0$bf7aeda0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000d01cf7adf$9528f9e0$bf7aeda0$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jingoo Han <jg1.han@samsung.com> [140528 18:45]:
> On Thursday, May 29, 2014 1:44 AM, Emil Goode wrote:
> > 
> > The struct menelaus_vtg pointer vtg cannot be NULL here
> > so the condition is never true and if it ever was true
> > it would lead to a NULL pointer dereference when we goto
> > label set_voltage.
> > 
> > Before the below patch was applied the code was:
> > 
> > if (vtg == 0)
> > 
> > The intention was to check if vtg_val is 0.
> > 
> > commit 59a9f7a32adf6537b4e4db8ca204eeb77d7a634e
> > ("mfd: menelaus: Use NULL instead of 0")
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> > v2: Changed (vtg_val == 0) to (!vtg_val)
> > 
> >  drivers/mfd/menelaus.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> > index ad25bfa..40df76a 100644
> > --- a/drivers/mfd/menelaus.c
> > +++ b/drivers/mfd/menelaus.c
> > @@ -466,7 +466,7 @@ static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
> >  	struct i2c_client *c = the_menelaus->client;
> > 
> >  	mutex_lock(&the_menelaus->lock);
> > -	if (!vtg)
> > +	if (!vtg_val)
> >  		goto set_voltage;
> 
> (+cc Trilok Soni, Tony Lindgren)
> 
> In this case, if 'vtg_val' is 0, setting voltage as 0 for
> registers such as MENELAUS_xxx_CTRLx will be skipped. So,
> it is not possible to set the voltage value as 0.
> 
> Is it right? If not, how about just removing this check and
> the label 'set_voltage'?

Added Aaro and Jarkko to Cc.

Regards,

Tony
 
> Best regards,
> Jingoo Han
> 
> > 
> >  	ret = menelaus_read_reg(vtg->vtg_reg);
> > --
> > 1.7.10.4
> 
