Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3K0VxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 16:53:18 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54821 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757411Ab3K0VxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 16:53:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gIROMm31O7CcnHkN+nEfx
Date: Wed, 27 Nov 2013 13:53:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131127215310.GC26766@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131124213651.59750C402C3@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131124213651.59750C402C3@trevor.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@linaro.org> [131124 13:37]:
> 
> I actually like the idea of completely allocating the resource structure
> but leaving some entries empty. However, I agree with rmk that putting
> garbage into a resource structure is a bad idea. What about changing the
> value of flags to 0 or some other value to be obviously an empty
> property and give the follow up parsing some context about which ones it
> needs to attempt to recalculate?

If we want to play it safe, we should probably introduce something like
this to ioport.h:

+#define IORESOURCE_IRQ_DEFERRED	(1<<6)

Then we can populate IRQ resources initially with that. And later on
during the driver probe, we know it's safe to populate the resource
if res->flags & IORESOURCE_IRQ_DEFERRED.

That fixes the $Subject bug, and gets us a little bit further for
making more changes later on.

Regards,

Tony
