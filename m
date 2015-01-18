Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbbARUS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 15:18:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32906 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbARUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 15:18:23 -0500
Date: Sun, 18 Jan 2015 21:18:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] ti-soc-thermal: implement eocz bit to make driver useful
 on omap3
Message-ID: <20150118201821.GA28530@amd>
References: <20150103114632.GA21883@amd>
 <20150103122634.GB22356@developer>
 <20150103162241.GA26680@amd>
 <20150105213557.GD31536@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105213557.GD31536@developer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, what do you suggest? AFAICT, without MODE_CONFIG, continuous ADC
> > mode is not available, so we have to force it periodically, so this
> > should be correct.
> 
> I will have a better look and let you know. for now, adding a single
> read should not hurt ( but I will double check)

Any news there?

> > > > +		if (ret)
> > > > +			return ret;
> > > > +	}
> > > > +
> > > >  	spin_lock(&bgp->lock);
> > > >  	temp = ti_bandgap_read_temp(bgp, id);
> > > >  	spin_unlock(&bgp->lock);
> > > >  
> > > > -	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> > > > +	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> > > 
> > > this one should be part of your clean up patch
> > 
> > Ok, can you apply the cleanup patch and I'll prepare one on the top of
> > it?
> 
> I mean, you should resend the cleanup patch including the above '|=' removal, as you are already doing in the cleanup patch.
> 

Ok, little patch-editing can not hurt :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
