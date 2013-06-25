Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3FYHbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:31:42 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27843 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274Ab3FYHbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:31:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18u21UPiXGYqYkkDzS0DSOi
Date: Tue, 25 Jun 2013 00:31:35 -0700
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
Message-ID: <20130625073134.GE5523@atomide.com>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
 <51BA1FE7.4000900@wwwdotorg.org>
 <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
 <51BB3A2C.608@wwwdotorg.org>
 <20130617072021.GB4465@atomide.com>
 <CACRpkdYwGHMznjoJqf5bX_74pmeKSiWtTwpNF1_4GSEk+KwrZA@mail.gmail.com>
 <20130617180212.GU20992@atomide.com>
 <CACRpkdY7hF+9s0f64yc09DHLFQCjzzhPoS-ypBmgit=kFFD0Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY7hF+9s0f64yc09DHLFQCjzzhPoS-ypBmgit=kFFD0Mg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130624 05:43]:
> On Mon, Jun 17, 2013 at 8:02 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Linus Walleij <linus.walleij@linaro.org> [130617 09:11]:
> 
> >> Bear in mind that struct pinctl * forks effects in two paths,
> >> one is muxing the other is config, like pull-ups etc.
> >
> > I also thought the plan was to merge pinmux and pinconf and
> > do things based the named modes?
> 
> That is done from a consumer point of view.
> Consumers only care about pinctrl * handles
> and pinctrl_state * switches.
> 
> > The last time I tried using the pinconf functions it involved
> > knowing the name of the pin in the consumer driver. The name
> > may not be very descriptive in the device tree cases at least
> > for the pinctrl-single. So I did not pay much attention to
> > the pinconf functions.
> 
> Consumers should not use that interface, i.e.:
> 
> int pin_config_get(const char *dev_name, const char *name,
>                                 unsigned long *config);
> int pin_config_set(const char *dev_name, const char *name,
>                                  unsigned long config)
> 
> This needs to be deleted from <linux/pinctrl/consumer.h>
> I'll see if I can get rid of it pronto to avoid any more confusion
> and sorry for leaving that in place for too long.
> 
> The proper way to use it is to use the states.

OK thanks for clarifying that. Yes I think the named states
is a good way to handle the pins in a generic way.

Regards,

Tony

