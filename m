Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3IXQvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:51:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37056 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038Ab3IXQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:51:24 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+uifc2incRzfe+lVjPCuhJ
Date: Tue, 24 Sep 2013 09:51:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Message-ID: <20130924165117.GQ2684@atomide.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
 <1373461145-9812-3-git-send-email-pali.rohar@gmail.com>
 <20130917232417.GK9994@atomide.com>
 <201309181033.24965@pali>
 <20130918171816.GT9994@atomide.com>
 <20130924001545.GA31569@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924001545.GA31569@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130923 17:23]:
> Hi!
> 
> > > Tony, if you did not have time for review this patch months ago 
> > > or you found it only today - no problem, I understand it. But 
> > > what I need to know is what will happen with board-rx51-* files 
> > > (and when?) You can see that DT does not have definitions of all 
> > > n900 hw parts (plus it is not in last 3.11 kernel!) which means 
> > > that DT is not usable for me and other n900 people. This also 
> > > means that I cannot rewrite my patches for DT and test if they 
> > > working.
> > 
> > I usually stop looking at new code around -rc4 and concentrate
> > on fixes until -rc1 or so. So there can be easily one month
> > delays on reviewing stuff depending on where we are with the
> > current merge window or -rc cycle, sorry if that's annoying.
> > 
> > The .dts files will be separate from the kernel soonish, so
> > that's not be a show stopper. Just like all the board specific
> > .config files are separate from the kernel already. Too bad our
> > .dts changes did not get merged for v3.12 because of conflicts
> > with other branches, but hey, they should be independent from the
> > kernel anyways.
> 
> Well... I'd say it is still time to merge them. "New hardware support"
> is ok after -rc1.

Sure if there's a good reason like "driver foo is already device
tree only and cannot be used for board bar without blah".
 
> > The board files will be going away as soon as things are working
> > with DT. We've been pretty much only applying fixes to them for
> > quite some time now. For the timeline, the earliest we'll be able
> > to remove the board-*.c files and platform data is for v3.13
> 
> And it would be good to merge n900 dts support for 3.12. Adding 
> device tree at the same release as removing board support files in
> same release leaves zero room for testing, and practically guarantees
> regressions.

Yes we experienced that with omap4 conversion where it caused
some wl12xx regression. So we might want to keep some omap3
board files around until v3.14 if necessary.

Also please take a look at the "[PATCH 0/4] Clean up legacy platform
data handling for omaps for v3.13" patches I posted few days ago,
those should make it easy to have board specific pdata quirks
for DT based booting.

Regards,

Tony
