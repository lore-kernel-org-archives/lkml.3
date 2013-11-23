Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab3KWBHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:07:18 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51056 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3KWBHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:07:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/grwIuKmmcOCqfg+RonSx8
Date: Fri, 22 Nov 2013 17:07:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131123010712.GM10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123004334.GJ10023@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131122 16:44]:
> @@ -168,7 +218,13 @@ struct platform_device *of_device_alloc(struct device_node *np,
>  			rc = of_address_to_resource(np, i, res);
>  			WARN_ON(rc);
>  		}
> -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
> +
> +		/* See of_device_resource_notify for populating interrupts */
> +		for (i = 0; i < num_irq; i++, res++) {
> +			res->flags = IORESOURCE_IRQ;
> +			res->start = -EPROBE_DEFER;
> +			res->end = -EPROBE_DEFER;
> +		}

Hmm actually we want to use some other value here as res->start
is not an int. Maybe some kind of hwirq_max + EPROBE_DEFER.

Tony
