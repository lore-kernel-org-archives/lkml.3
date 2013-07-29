Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3G2JF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:05:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28836 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751652Ab3G2JF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:05:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+kYImXcZ8YKmhodPVD8ash
Date: Mon, 29 Jul 2013 02:05:24 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
Message-ID: <20130729090524.GY7656@atomide.com>
References: <20130716090310.5541.36777.stgit@localhost>
 <20130716090536.5541.36289.stgit@localhost>
 <51E70953.1000601@wwwdotorg.org>
 <20130718072034.GO7656@atomide.com>
 <51E8401E.8040705@wwwdotorg.org>
 <20130719072927.GY7656@atomide.com>
 <51E98AEC.5000802@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E98AEC.5000802@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130719 11:59]:
> On 07/19/2013 01:29 AM, Tony Lindgren wrote:
> > 
> > I'd vote for keeping the existing behaviour with pinctrl_select_state()
> > when no active state is defined.
> 
> Yes, I think that will work, since the active state cannot exist before
> this new scheme is in place.

Right.
 
> But, this needs to be very clearly spell out in the DT binding
> documentation: If you have states default/idle/sleep, they're complete
> alternatives, whereas if you have states default/active/idle/sleep, the
> latter 3 are alternatives that build on top of the first. I foresee mass
> confusion, but perhaps I'm being pessimistic.

I'm hoping we can automate the runtime PM handling with default/active/idle
completely from the consumer driver point of view. And then when that's
working, we can probably deprecate any runtime PM related handling using
pinctr_select_state() and print warnings. And we can also improve the
documentation so no new users will use the default/idle/sleep for runtime
PM unless they really want to.

Regards,

Tony

