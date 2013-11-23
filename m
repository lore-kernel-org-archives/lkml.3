Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3KWBJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:09:00 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24916 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755798Ab3KWBI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:08:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19G/IyTtvoZcVxsf/+wrh5z
Date: Fri, 22 Nov 2013 17:08:51 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131123010850.GN10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131123005509.GJ16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123005509.GJ16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> > +		/* See of_device_resource_notify for populating interrupts */
> > +		for (i = 0; i < num_irq; i++, res++) {
> > +			res->flags = IORESOURCE_IRQ;
> > +			res->start = -EPROBE_DEFER;
> > +			res->end = -EPROBE_DEFER;
> 
> NAK.  Definitely a bad idea to start introducing magic values other into
> resources.  Please don't do this.

Do you have any better ideas on how to sort out this issue then?

Tony
