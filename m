Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab3FLSd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:33:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26130 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756019Ab3FLSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:33:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/pipmvqaTZbA5t6TbJAwZc
Date: Wed, 12 Jun 2013 11:33:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
Message-ID: <20130612183345.GU8164@atomide.com>
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
 <51B75148.5080701@wwwdotorg.org>
 <CACRpkdYQSO0+9tQkS=df-kpL=XL+DpnY1ijp6_Zeg0MvmFujyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYQSO0+9tQkS=df-kpL=XL+DpnY1ijp6_Zeg0MvmFujyw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130611 12:59]:
> On Tue, Jun 11, 2013 at 6:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 06/11/2013 02:16 AM, Linus Walleij wrote:
> >> From: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> In addition to the recently introduced pinctrl core
> >> control, the PM runtime pin control for the OMAP platforms
> >> require a fourth state in addtition to the default, idle and
> >> sleep states already handled by the core: an explicit "active"
> >> state. Let's introduce this to the core in addition to the
> >> other states already defined.
> >
> > Surely "default" /is/ "active"? That's what it's meant so far.
> 
> I thought so too, until Tony informed us that in the OMAP world
> this state is not always the active one.
> 
> But I don't know the exact reasons for.
> 
> I guess that some "default" states on the OMAP may mean these
> are configured as decoupled, inactive, until explicitly activated
> or something like that.

The main reason is that remuxing all the pins for a device for
PM runtime suspend and resume is not necessary. Most pins are
static and configured once during the consumer driver probe.
And in most cases, remuxing only one pin for the rx line is
needed. This is performance critical as it may need to be done
constantly while entering and exiting idle, and remuxing all the
pins is just a waste of cycles.

Regards,

Tony 
