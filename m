Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3IWSDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:03:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28624 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3IWSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:03:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BuPKDHi77MAQM2pKeEqbX
Date: Mon, 23 Sep 2013 11:03:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a
 charger
Message-ID: <20130923180259.GJ2684@atomide.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1378630239-10006-5-git-send-email-pali.rohar@gmail.com>
 <201309202122.06327@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309202122.06327@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130920 12:29]:
> On Sunday 08 September 2013 10:50:39 Pali Rohár wrote:
> > This patch will register bq24150a charger in RX-51 board data.
> > Patch also adding platform function between isp1704 and
> > bq2415x drivers for detecting charger type.
> > 
> > So finally charging battery on Nokia N900 (RX-51) working
> > automatically without any proprietary Nokia bits in userspace.
...
 
> > @@ -277,6 +316,7 @@ static void rx51_charger_set_power(bool
> > on)
> > 
> >  static struct isp1704_charger_data rx51_charger_data = {
> >  	.set_power	= rx51_charger_set_power,
> > +	.set_current	= rx51_charger_set_current,
> >  };

We want to get rid of the platform data callbacks here,
there no longer any need to keep these under arch/arm.

> Tony, can you look and review this board patch?

Yes, looks like this can all be done in the driver nowadays.
You can use drivers/reset for the set_power. Or if it's really
controlling the regulator, then the regulator framework. The
info can be passed in a .dts file for those.

The .set_current you can do in the driver based on the
compatible flag.
 
> I think that this patch series it the most important for Nokia 
> N900, because it finally bringing charging support. And without 
> charging battery it very hard to use phone which has power supply 
> only from battery.

Right, let's get this driver updated to use the device tree
based init and that way this file is no longer needed.
I would like to $ grep -i grandmom ~/.phonebook | call too :)

I forgot how this charger is wired up, but maybe take a
look at commit d7bf353f (bq24190_charger: Add support for TI
BQ24190 Battery Charger) for the DT parts.

Regards,

Tony
