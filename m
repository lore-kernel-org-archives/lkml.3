Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab3GQVKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 17:10:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:15915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3GQVKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 17:10:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,687,1367996400"; 
   d="scan'208";a="332936531"
Date: Wed, 17 Jul 2013 23:10:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
Message-ID: <20130717211021.GB19864@zurbaran>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1374052705.3146.86.camel@hornet>
 <alpine.LFD.2.03.1307170825240.14924@syhkavp.arg>
 <1374067786.3146.123.camel@hornet>
 <alpine.LFD.2.03.1307171014510.14924@syhkavp.arg>
 <1374070811.3146.124.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374070811.3146.124.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Wed, Jul 17, 2013 at 03:20:11PM +0100, Pawel Moll wrote:
> On Wed, 2013-07-17 at 15:16 +0100, Nicolas Pitre wrote:
> > On Wed, 17 Jul 2013, Pawel Moll wrote:
> > 
> > > On Wed, 2013-07-17 at 13:33 +0100, Nicolas Pitre wrote:
> > > > If this is really miscelaneous code that really doesn't fit 
> > > > anywhere else, it should rather go into drivers/misc/ as a last resort.
> > > 
> > > Interestingly enough drivers/misc was my first choice for all the
> > > vexpress stuff, but it wasn't received well...
> > > 
> > > Anyway, the SPC driver as it is now seem to be a "power management
> > > system driver". Maybe a relevant directory would be in place? Wouldn't
> > > PSCI belong there as well? (there are two psci.c files in arch/arm and
> > > arch/arm64, surprisingly similar ones ;-)
> > > 
> > > The bottom line is: today it is not an MFD driver.
> > 
> > But we know it will, right?  So better  save some churn by storing the 
> > initial code where it would end up anyway once complete.
> 
> Not in that form, no. The code living in mfd will just register
> mfd_cells while "functional" parts are going to live elsewhere. This is
> how I understand what Samuel asked me to do and that's what is happening
> to vexpress-sysreg now.
Very good, I'll happily apply such changes.
If I understand the IP correctly, the SPC driver will stay as a set of
runtime APIs for controlling the SPC features. If that's the case, then
misc sounds like a more appropriate place for this driver.
drivers/power/ really is for power supplies and charging drivers.

Cheers,
Samuel. 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
