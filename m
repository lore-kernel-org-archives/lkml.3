Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbbAULBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:01:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54089 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbAULBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:01:33 -0500
Date: Wed, 21 Jan 2015 12:01:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] bluetooth: Add hci_h4p driver
Message-ID: <20150121110131.GA19792@amd>
References: <20141223130219.GA5731@amd>
 <CB643345-4B50-4ED0-8C3E-296CD225754D@holtmann.org>
 <20150120173604.GA712@amd>
 <7522CAC7-AFD9-470F-B4F8-3C39942DBC04@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7522CAC7-AFD9-470F-B4F8-3C39942DBC04@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Speaking about formatting, could you properly format your emails, that
> > is inserting newline after ~78 columns, to make them easier to reply
> > to?
> 
> or you get an email client that can handle that part.

My email client is configured ok. Your is not. You are speaking on
public mailing list, so you should follow the rules.

> > Strange, where do you see DOS style line breaks? Checkpatch here does
> > not warn about that, and they really should not be there.
> 
> If that would be the only pieces, then I would have fixed it already. That is not the big deal. The rest of checkpatch is what I am not going to fix for you.
>

I can fix the checkpatch, but I'd like to understand how ^Ms got
there, because otherwise it will happen again.

> > Yeah, so first patch was too good for staging, and I "would be allowed
> > to clean it up in tree", and now you run checkpatch --strict,
> > complaining about very serious stuff such as "blank lines before }".
> 
> The network subsystem requires the --strict option.
> 
> Please stop complaining about staging. The patch went in, it was ignored for month and multiple kernel release and it got removed. Deal with it.
> 

Yes. It took me one 7 months to set up development environment. You
decided you don't like staging, so you made sure it does not work for
me -- by removing the driver. Thus, I had not only cleanups to do, but
also resulting bitrot. And now, because you don't like staging, are
making sure that I'll have to deal with bitrot and device tree at the
same time.

> The indentations ones need to be fixed.

Ok, done.

> >> Also this worries me:
> >> 
> >> WARNING: DT compatible string "brcm,uart,bcm2048" appears un-documented -- check ./Documentation/devicetree/bindings/
> >> #1222: FILE: drivers/bluetooth/nokia_core.c:1129:
> >> +	{ .compatible = "brcm,uart,bcm2048" },
> > 
> > Yes, that wories me, too. It is one of reasons I wanted this to be
> > merged to staging. Arguing about right bindings will take some time.
> 
> Then that needs to be figured out. It is not that I have mentioned DT for the first time. I said that right from the beginning.
>

>From the beginning of the second try. I'll try to figure it out with
the dt people.

> > I can fix the checkpatch stuff that makes sense. That does not include
> > uglyfying code just for checkpatch.  Can you then take the patch, as
> > you promised, and let me argue the bindings, and the other stuff that
> > needs to be fixed?
> > 
> > If not, can we agree that the driver in staging should be reverted, as
> > Greg promised would be "easy", and I can clean it up there?
> 
> I am refusing to allow this into staging. Get this into shape for drivers/bluetooth/ or keep the driver external.
> 

After all the work that gone into the driver, you could at least state
the reason. I guess I have demonstrated by now that someone cares
about the driver.

For the record, reason I want it in the staging is that I don't want
driver to bitrot while dt people do their bikeshed discussion.

Regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
