Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaKXTui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:50:38 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43820 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754274AbaKXTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:50:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ykYJqS2doy6j1oC0ChMFp
Date: Mon, 24 Nov 2014 11:47:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling
 invalid BB-bit values
Message-ID: <20141124194759.GG2757@atomide.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
 <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141124 11:41]:
> 
> 24 нояб. 2014 г., в 22:08, Kevin Hilman <khilman@kernel.org> написал(а):
> 
> > This patch recently hit linux-next (as commit 903c3859f77f) and boot
> > breakage[1] in next-20141124 on OMAP3530 Beagle and Overo/Tobi boards
> > was bisected down to this commit.
> > 
> > Kevin
> > 
> > [1] http://status.armcloud.us/boot/?next-20141124&omap
> 
> 
> Could someone advice with debugging on OMAP3530?

Just try to boot it with your patch? :)
 
> I'd like to apply one one more commit to see events during boot and
> see actual signals on wire (during of timeout)?

If you post a patch, I can test boot with it. Looks like the failing
ones have i2c rev3.3 on 34xx vs rev4.4 on 36xx.

But the test function should not loop forever in any case I take?

So I doubt we just want to change the test for for a higher rev number
for  OMAP_I2C_REV_ON_3430_3530.
 
> Otherwise, commit must dropped (or rewritten such way it is disabled by default).
> 
> 
> 24 нояб. 2014 г., в 22:13, Wolfram Sang <wsa@the-dreams.de> написал(а):
> 
> > OK, giving Alexander some time for a fix. If it can't be found, I'll
> > revert this patch. Thanks!
> 
> What deadline?

I'd say by Tuesday as we have multiple automated test systems failing
as soon as people update their trees. And when they are failing, we
may miss other breakage happening in linux next.

Regards,

Tony
