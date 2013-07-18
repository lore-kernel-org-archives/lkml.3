Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab3GRKxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:53:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62969 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758667Ab3GRKxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:53:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX194cOtaVPjwKgzhcjtTNIAw
Date: Thu, 18 Jul 2013 03:53:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130718105345.GV7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <51E70953.1000601@wwwdotorg.org>
 <20130718072034.GO7656@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718072034.GO7656@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [130718 00:31]:
> * Stephen Warren <swarren@wwwdotorg.org> [130717 14:21]:
> > On 07/16/2013 03:05 AM, Tony Lindgren wrote:
> > > +int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *st1,
> > > +			  struct pinctrl_state *st2)
> > > +{
> > > +	struct pinctrl_setting *s1, *s2;
> > > +
> > > +	list_for_each_entry(s1, &st1->settings, node) {
> > ...
> > > +		list_for_each_entry(s2, &st2->settings, node) {
> > ...
> > > +			if (pctldev1 != pctldev2) {
> > > +				dev_dbg(dev, "pctldev must be the same for states\n");
> > > +				return -EINVAL;
> > > +			}
> > 
> > I don't think we should require that; it's perfectly legal at the moment
> > for some device's pinctrl configuration to include settings from
> > multiple different pin controllers.
> 
> Yes that's fine for pinctrl_select(), but let's not do that for
> runtime muxing.

Hmm reading this again, you're right, there should not be anything
preventing mixing multiple controllers as long as the states match.
 
> > > +			for (i = 0; i < num_pins1; i++) {
> > > +				int pin1 = pins1[i];
> > > +
> > > +				for (j = 0; j < num_pins2; j++) {
> > > +					int pin2 = pins2[j];
> > > +
> > > +					if (pin1 == pin2) {
> > > +						found++;
> > > +						break;
> > > +					}
> > > +				}
> > > +			}
> > > +
> > > +			if (found != num_pins1) {
> > 
> > I guess this make sure that every entry in the dynamic state is in the
> > state state, but not vice-versa; the static state can affect more stuff
> > than the dynamic state?
> > 
> > If so, shouldn't that check be if (found != num_pins2)?
> 
> The check is that idle_state and sleep_state pins must match the
> active_state pins. This is intentionally different from the current
> pinctrl_select() logic.

And here things will get messed up if the order of settings is diffrent..
So yes, pinctrl_check_dynamic() needs more work.

Regards,

Tony
