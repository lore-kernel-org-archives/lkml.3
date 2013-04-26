Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3DZNcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:32:52 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:38346 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3DZNcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:32:50 -0400
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 09:32:50 EDT
Date: Fri, 26 Apr 2013 09:12:20 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: "David Laight" <David.Laight@ACULAB.COM>
Cc: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-atm-general@lists.sourceforge.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 05/21] atm: he: use mdelay instead of large udelay
 constants
Message-ID: <20130426091220.468cf59e@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7203@saturn3.aculab.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
	<1366910944-3033663-6-git-send-email-arnd@arndb.de>
	<AE90C24D6B3A694183C094C60CF0A2F6026B7203@saturn3.aculab.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=0
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013 09:21:59 +0100
"David Laight" <David.Laight@ACULAB.COM> wrote:

> > ARM cannot handle udelay for more than 2 miliseconds, so we
> > should use mdelay instead for those.
> ...
> > @@ -1055,7 +1055,7 @@ static int he_start(struct atm_dev *dev)
> >  	he_writel(he_dev, 0x0, RESET_CNTL);
> >  	he_writel(he_dev, 0xff, RESET_CNTL);
> > 
> > -	udelay(16*1000);	/* 16 ms */
> > +	mdelay(16);	/* 16 ms */
> >  	status = he_readl(he_dev, RESET_CNTL);
> 
> 16ms seems a long time to spin.
> I'd have thought a sleep would be more appropriate.
> Since this looks like timing a hardware reset pulse
> it can't matter if it is somewhat longer.

Yes, I wrote this bit some time ago when I was less wise. The
programmer's guide doesn't say how long to sleep, so the value isn't
critical.  It just has to be "long enough".  An msleep() would be fine
here.
