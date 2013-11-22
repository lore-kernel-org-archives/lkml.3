Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3KVRLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:11:42 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28453 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3KVRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:11:39 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LAHcCH6P+UWnOtUlRjkLu
Date: Fri, 22 Nov 2013 09:11:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org,
        santosh.shilimkar@ti.com, jgchunter@gmail.com, rnayak@ti.com,
        balbi@ti.com
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
Message-ID: <20131122171135.GH10023@atomide.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-7-git-send-email-joelf@ti.com>
 <20131122155838.GF10023@atomide.com>
 <528F8EC4.9050506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F8EC4.9050506@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131122 09:06]:
> On 11/22/2013 09:58 AM, Tony Lindgren wrote:
> > * Joel Fernandes <joelf@ti.com> [131121 18:00]:
> >> +Required properties for system timers (clockevents/clocksource):
> >> +- ti,timer-parent:	System timer's parent mux clock needs to be setup.
> >> +			This is currently hardcoded in code, for DT boot we
> >> +			move this to DT.
> >> +
> > 
> > This can be replaced with just clk_set_rate, or clk_set_parent if needed.
> > Or by having a clocks = <&32k_clk> property in the dmtimer node in the
> > .dts file.
> > 
> >>  Optional properties:
> >>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
> > 
> > Hmm this we may not need, this can probably be deciphered from the compatible
> > flag already?
> 
> I was thinking maybe we can improve the of_clocksource_init matching
> capabilities to match better, not just on compatible but other properties for
> better selection?
> 
> For example, a generic clocksource DT property to say that the timer is in the
> wakeup domain and so should be preferred as the clocksource? Also additional
> properties to force its selection?
> 
> Then we can switch to clocksource_of_init and have it do the selection. Not sure
> if there is such a need or value for other ARM platforms so we may be over
> complicating the framework to handle these quirks. Comments welcomed about it.

Maybe, but so far it seems that it can all be specified in the board specific
.dts file using standard properties, so I'd first play with that.

Regards,

Tony
