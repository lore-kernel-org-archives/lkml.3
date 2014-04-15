Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaDOVha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:37:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDOVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:37:28 -0400
Date: Tue, 15 Apr 2014 23:37:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rabin Vincent <rabin@rab.in>
Cc: balbi@ti.com, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pali.rohar@gmail.com,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: Fix obex in g_nokia.ko causing kernel panic
Message-ID: <20140415213724.GA819@amd.pavel.ucw.cz>
References: <20140205230634.GA25598@kroah.com>
 <1391714737-6835-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <CAH+eYFAnc+k+3kSH4_YDRG-zX_ioBwZ_jGdpyvUWFqf_=6kYGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+eYFAnc+k+3kSH4_YDRG-zX_ioBwZ_jGdpyvUWFqf_=6kYGA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > From: Felipe Balbi <balbi@ti.com>
> 
> This patch, which is present in 3.14-rc4 as 30a70b026 ("usb: musb: fix
> obex in g_nokia.ko causing kernel panic"), breaks USB gadget support
> on my Pandaboard.  Bisecting points to this commit, reverting it makes
> USB gadget support work again.  The problem is that this patch deletes
> the call which turns on the PHY.
> 
> Config is attached.

Can you try adding 

static int omap2430_musb_init(struct musb *musb)
{
...
+	phy_power_on(musb->phy);
	return 0;
...
}	


?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
