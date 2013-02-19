Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab3BSOxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:53:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:13803 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab3BSOxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:53:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="289076589"
Message-ID: <1361285612.2323.22.camel@rzhang1-mobl4>
Subject: RE: thermal governor: does it actually work??
From: Zhang Rui <rui.zhang@intel.com>
To: Alexander Lam <azl@andrew.cmu.edu>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "peter@piie.net" <peter@piie.net>
Date: Tue, 19 Feb 2013 22:53:32 +0800
In-Reply-To: <CACWwPit=xxeeCW1+jfxE8eww+P545B5xebh3YT2yE78zcsqSMg@mail.gmail.com>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
	 <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
	 <20130215154931.GA26213@rhlx01.hs-esslingen.de>
	 <CACWwPisqpmLjiqEh+J2DjnEtNObmmA0w=qMQYTgBsb6Ntad7Pw@mail.gmail.com>
	 <744357E9AAD1214791ACBA4B0B90926329F98E@SHSMSX101.ccr.corp.intel.com>
	 <CACWwPit=xxeeCW1+jfxE8eww+P545B5xebh3YT2yE78zcsqSMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 15:26 -0500, Alexander Lam wrote:
> 
> On Feb 18, 2013 7:11 AM, "Zhang, Rui" <rui.zhang@intel.com> wrote:
> >
> > Sorry I missed that patch.
> >
> > So the problem happens when the acerhdf thermal zone is registered
> when the fan has already been spinning, right?
> 
> Correct, when the acerhdf driver is switched into kernel controlled
> mode and the fan is spinning, it stays spinning until the temperature
> goes above the fan-on trip point and then below the fan-off trip
> point. then the fan shuts off.
> 
> I don't have an opinion on how this is fixed, so do whatever you want
> with my patch. Maybe you should drop it entirely if we do end up
> applying Peter's fix.

> >
> >  
> >
> > Thanks,
> >
> > rui
> >
> >  
> >
> > From: Alexander Lam [mailto:azl@andrew.cmu.edu] 
> > Sent: Sunday, February 17, 2013 4:56 AM
> > To: Andreas Mohr
> > Cc: Zhang, Rui; linux-kernel@vger.kernel.org; R, Durgadoss;
> peter@piie.net; lenb@kernel.org
> > Subject: Re: thermal governor: does it actually work??
> > Importance: High
> >
> >  
> >
> > I wrote a patch to fix this:
> >
> >
> > http://lkml.org/lkml/2012/12/30/47

I think this is the right fix, but I still need to check if there is
some extra work needed before applying it.

thanks,
rui
> >
> > But nobody picked it up and since then I have been too busy to
> respin the patch for new -rc kernels.
> >
> > -Alexander Lam
> >
> > On Fri, Feb 15, 2013 at 10:49 AM, Andreas Mohr <andi@lisas.de>
> wrote:
> >
> > Hi,
> >
> >
> > On Fri, Feb 15, 2013 at 09:47:07AM +0000, Zhang, Rui wrote:
> > > Please attach the output of
> > > "grep . /sys/class/thermal/thermal_zone*/cdev*/*"?
> >
> > # grep . /sys/class/thermal/thermal_zone*/cdev*/*
> > /sys/class/thermal/thermal_zone0/cdev0/cur_state:1
> > /sys/class/thermal/thermal_zone0/cdev0/max_state:1
> > grep: /sys/class/thermal/thermal_zone0/cdev0/power: Is a directory
> > grep: /sys/class/thermal/thermal_zone0/cdev0/subsystem: Is a
> directory
> > /sys/class/thermal/thermal_zone0/cdev0/type:acerhdf-fan
> >
> >
> > > The question is that if we can also call it "throttle" when
> reducing the device performance to generate less heat.
> >
> > I won't continue to elaborate on this separate issue now, given that
> my time
> > currently is very limited ;)
> >
> >
> > Andreas Mohr
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >  
> 
> -Alexander Lam
> 


