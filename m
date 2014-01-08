Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbaAHVoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:44:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39583 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaAHVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:44:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199jLllW7W2Sujx7qYDTcOh
Date: Wed, 8 Jan 2014 13:43:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Paul Walmsley <paul@pwsan.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references
 late
Message-ID: <20140108214354.GG31323@atomide.com>
References: <20140108011957.GK5074@atomide.com>
 <1389185477-507-1-git-send-email-treding@nvidia.com>
 <20140108164040.GA31686@atomide.com>
 <20140108192830.GA1298@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108192830.GA1298@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [140108 11:32]:
> On Wed, Jan 08, 2014 at 08:40:41AM -0800, Tony Lindgren wrote:
> > 
> > There's nothing wrong with the interrupt related code paths, we're just
> > trying to call the functions at a wrong time when thing are not yet
> > initialized.
> 
> The patch won't get rid of that warning, but it should at least restore
> things to a working state at runtime. At least for well-behaved drivers
> that use platform_get_irq() rather than those that try to access the
> resources directly.

Well the problem I'm seeing is these nasty warnings.

BTW, I think the issue you're talking about regarding platform_get_irq()
got fixed by 4a43d686fe33 (of/irq: Pass trigger type in IRQ resource flags).
 
> > Below is a repost of what works for me without using notifiers. Anybody
> > got any better ideas for a minimal fix?
> 
> That patch is somewhat big for something that should be a minimal fix.
> Being the size that it is it might have undesired side-effects that may
> not get noticed until it's way too late, so I'm hesitant to have
> something like this merged at this point in the release cycle.

Yes I agree it's rather invasive, but we also do have things pretty
badly broken in the kernel for device tree based booting. And it seems
that nobody has a smaller patch that would fix it.

Regards,

Tony
