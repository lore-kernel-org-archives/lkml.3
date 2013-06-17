Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3FQSCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:02:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:50536 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab3FQSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:02:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18NlHeHEk9T2TT8ReZ1hpyw
Date: Mon, 17 Jun 2013 11:02:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
Message-ID: <20130617180212.GU20992@atomide.com>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
 <51BA1FE7.4000900@wwwdotorg.org>
 <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
 <51BB3A2C.608@wwwdotorg.org>
 <20130617072021.GB4465@atomide.com>
 <CACRpkdYwGHMznjoJqf5bX_74pmeKSiWtTwpNF1_4GSEk+KwrZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYwGHMznjoJqf5bX_74pmeKSiWtTwpNF1_4GSEk+KwrZA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130617 09:11]:
> On Mon, Jun 17, 2013 at 9:20 AM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > First, I think the concept of remuxing (or even checking) _all_ the pins
> > for a consumer device is wrong on most if not all hardware. For past 10
> > years I have not seen a case where _all_ the pins for a device would need
> > to be remuxed for any reason.
> 
> We may be talking past each other here. On the ux500 we use a lot
> of runtime pincontrol, but none of this is *remuxing*.
> 
> We are only *reconfiguring*.

Hmm routing the signal to a different device is certainly
remuxing but yeah configuring pulls etc does not change the
mux.
 
> Now I know that Haojian only recently added pin config to the
> pinctrl-single.c driver so maybe you have mostly seen muxing
> in your driver so far, so you view of the world is a bit different.
> 
> On the Nomadik pin controller we do mostly hogged muxing
> at boot time, but a lot of runtime reconfiguration. So our
> needs are very different.
> 
> Bear in mind that struct pinctl * forks effects in two paths,
> one is muxing the other is config, like pull-ups etc.

I also thought the plan was to merge pinmux and pinconf and
do things based the named modes?

The last time I tried using the pinconf functions it involved
knowing the name of the pin in the consumer driver. The name
may not be very descriptive in the device tree cases at least
for the pinctrl-single. So I did not pay much attention to
the pinconf functions.

Sorry if I'm confused, but maybe you can try to help me
understand how you would handle the following:

Let's assume you'd want to reconfigure MMC DAT lines with pulls
for idle and not touch the CLK and CMD lines.

How does the MMC driver know the DAT lines to configure with
pinconf?

And then how would you do set up the pins so that we can set
them up automatically for consumer drivers in
drivers/base/pinctrl.c?

Regards,

Tony

