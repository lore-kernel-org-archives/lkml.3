Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3ATUvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 15:51:08 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55437 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3ATUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 15:51:06 -0500
Date: Sun, 20 Jan 2013 12:47:29 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] power: reset: qnap-poweroff: Fix License String
Message-ID: <20130120204728.GA16339@lizard.gateway.2wire.net>
References: <20130106215509.GD26928@lizard.sbx05280.losalca.wayport.net>
 <1357668926-20598-1-git-send-email-andrew@lunn.ch>
 <20130120201336.GO8668@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130120201336.GO8668@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 09:13:36PM +0100, Uwe Kleine-König wrote:
> On Tue, Jan 08, 2013 at 07:15:26PM +0100, Andrew Lunn wrote:
> > GPLv2+ is not a valid license string. Replace it with one that is.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/power/reset/qnap-poweroff.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/power/reset/qnap-poweroff.c b/drivers/power/reset/qnap-poweroff.c
> > index ca0b476..8af772b 100644
> > --- a/drivers/power/reset/qnap-poweroff.c
> > +++ b/drivers/power/reset/qnap-poweroff.c
> > @@ -121,4 +121,4 @@ module_platform_driver(qnap_power_off_driver);
> >  
> >  MODULE_AUTHOR("Andrew Lunn <andrew@lunn.ch>");
> >  MODULE_DESCRIPTION("QNAP Power off driver");
> > -MODULE_LICENSE("GPLv2+");
> > +MODULE_LICENSE("GPL v2");
> This change is wrong.
> 
> According to include/linux/module.h "GPL v2" means exactly that: version
> 2. As the file specifies v2 or later in the header you have to use "GPL"
> which means v2 or later.

Does it even make sense to have the two separate things ("GPL v2" and
"GPL")?

Suppose there is a global change that modifies a bunch of drivers, some of
them are GPLv2+. Now, the author of the global change is submitting it
under "GPL v2 only" license, which, by definition, turns any GPLv2+ code
into "GPL v2 only", right?

So, changing from GPLv2+ to "GPL v2 only" is OK, but not the other way
around.

IANAL, tho.

Anton

p.s. Yes, in this particular driver it also makes sense to remove "or
later" words from the header, just to be consistent.
