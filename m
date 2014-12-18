Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaLRUKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:10:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55319 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:10:46 -0500
Date: Thu, 18 Dec 2014 21:10:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141218201043.GA15240@amd>
References: <20141213223727.GA13894@amd>
 <1418637710.4443.11.camel@linux-0dmf.site>
 <20141218193153.GA27832@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218193153.GA27832@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Thu 2014-12-18 20:31:53, Pavel Machek wrote:
> Hi!
> 
> > > +	h4p_simple_send_frame(info, skb);
> > > +
> > > +	if (!wait_for_completion_interruptible_timeout(&info->init_completion,
> > > +						       msecs_to_jiffies(1000))) {
> > > +		printk("h4p: negotiation did not return\n");
> > 
> > Memory leak in the error case
> 
> And memory leak in the normal case, too, no? Fixed.

Actually, no, h4p_simple_send_frame passes skb to network stack, and
it should free it as neccessary.

								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
