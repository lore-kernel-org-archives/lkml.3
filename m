Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EFMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:09:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35663 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3EFMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:09:27 -0400
Date: Mon, 6 May 2013 14:09:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] PM: Fix dev_pm_put_subsys_data() to not call kfree()
 while holding device power lock
Message-ID: <20130506120925.GA25542@amd.pavel.ucw.cz>
References: <1367614010.8452.2.camel@lorien>
 <20130504125116.GA13770@amd.pavel.ucw.cz>
 <1882177.s6zpHZ6crc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1882177.s6zpHZ6crc@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Wow, that function is fragile. It returns 0/1/-EINVAL, while being
> > documented for 0/1...
> 
> Oh, it generally should return 1 for !psd.
> 
> > Patch does not look obviously wrong, but maybe 
> > 
> > @@ -73,13 +73,17 @@ int dev_pm_put_subsys_data(struct device *dev)
> >  
> >  	if (--psd->refcount == 0) {
> >  		dev->power.subsys_data = NULL;
> > +		spin_unlock_irq(&dev->power.lock);
> > -		kfree(psd);
> > - 		ret = 1;
> > +		return 1;
> >  	}
> > 
> > Would be cleaner.
> 
> What about this:

Looks good to me.

Reviewed-by: Pavel Machek <pavel@ucw.cz>

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
