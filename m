Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3KSPlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:41:03 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61486 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3KSPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:40:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hi2ByEFVD0YKlcQoyRv7e
Date: Tue, 19 Nov 2013 07:40:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
Subject: Re: [PATCH v2 0/3] Add support for charging battery in Nokia RX-51
Message-ID: <20131119154052.GB10317@atomide.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <20131119144407.GB28455@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131119144407.GB28455@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131119 06:45]:
> Hi Pali,
> 
> On Tue, Nov 19, 2013 at 11:18:02AM +0100, Pali Rohár wrote:
> > This patch series finally bringing support for charging battery on
> > Nokia N900 (RX-51) without any proprietary Nokia bits in userspace.
> 
> YAY! :)
> 
> > I removed hook function from bq2415x_charger driver and replaced it
> > by Jenny TC power_supply notifier code. This simplify usage of
> > bq2415x driver and also allow adding DT support in future because
> > driver does not need board specific function anymore (only static data).
> > 
> > I tested this series with linux 3.12-rc5 on Nokia N900.
> 
> cool :)
> 
> Do you want me to take this up and add DT support?

Great news, yeah let's add this with DT support instead as we're
planning to switch over to DT only booting anyways. The values can be
probably set directly in the charger driver based on the compatible
flag.

Note that we can also still add the I2C devices as needed from
the pdata-quirks.c, but in this case there should not be any need
for it :)

Regards,

Tony
