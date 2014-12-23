Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaLWMAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:00:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32995 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbaLWMAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:00:51 -0500
Date: Tue, 23 Dec 2014 13:00:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH]  bluetooth: Add hci_h4p driver
Message-ID: <20141223120048.GA848@amd>
References: <20141213223727.GA13894@amd>
 <20141220202314.GA8484@amd>
 <D5E3AD8F-9122-49FE-B932-F9DDBB89840F@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5E3AD8F-9122-49FE-B932-F9DDBB89840F@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +	/* We should always send word aligned data to h4+ devices */
> > +	if (skb->len % 2) {
> > +		err = skb_pad(skb, 1);
> > +		if (!err)
> > +			*skb_put(skb, 1) = 0x00;
> > +	}
> > +	if (err)
> > +		return err;
> 
> This is crazy code.
> 
> 	if (skb->len % 2) {
> 		if (!skb_pad(skb, 1)
> 			return -ENOMEM;
> 		*skb_put(skb, 1) = 0x00;
> 	}

This does not work, it needs to be if (skb_pad())... and it does not
propagate error value. Took me few boots to debug, as I still can't
scroll back after kernel crash...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
