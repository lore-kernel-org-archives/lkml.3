Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaAVLA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:00:27 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40068 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaAVLAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:00:24 -0500
Date: Wed, 22 Jan 2014 11:00:18 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power domain
 look-up
Message-ID: <20140122110018.GB24288@e102568-lin.cambridge.arm.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
 <20140116163409.GD25540@e102568-lin.cambridge.arm.com>
 <52DD5DC5.3000908@samsung.com>
MIME-Version: 1.0
In-Reply-To: <52DD5DC5.3000908@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Jan 2014 11:00:19.0589 (UTC) FILETIME=[23BD0350:01CF1761]
X-MC-Unique: 114012211002007601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:32:53PM +0000, Tomasz Figa wrote:
> Hi Lorenzo,
> 
> On 16.01.2014 17:34, Lorenzo Pieralisi wrote:
> > Hi Tomasz,
> >
> > thank you for posting this series. I would like to use the DT bindings
> > for power domains in the bindings for C-states on ARM:
> >
> > http://comments.gmane.org/gmane.linux.power-management.general/41012
> >
> > and in particular link a given C-state to a given power domain so that the
> > kernel will have a way to actually check what devices are lost upon C-state
> > entry (and for devices I also mean CPU peripheral like PMUs, GIC CPU IF,
> > caches and possibly cpus, all of them already represented with DT nodes).
> >
> > I have a remark:
> >
> > -  Can we group device nodes under a single power-domain-parent so that
> >     all devices defined under that parent won't have to re-define a
> >     power-domain property (a property like interrupt-parent, so to speak)
> >
> > What do you think ?
> 
> Hmm, I can see potential benefits of such construct on platforms with 
> clear hierarchy of devices, but to make sure I'm getting it correctly, 
> is the following what you have in mind?
> 
> soc-domain-x@12340000 {
> 	compatible = "...";
> 	reg = <...>;
> 	power-domain-parent = <&power_domains DOMAIN_X>;
> 
> 	device@1000 {
> 		compatible = "...";
> 		// inherits power-domain = <&power_domains DOMAIN_X>
> 	};
> 
> 	device@2000 {
> 		compatible = "...";
> 		// inherits power-domain = <&power_domains DOMAIN_X>
> 	};
> };

Yes, exactly, it could avoid duplicated data. I still have an issue
with nodes that are per-cpu but define just one node (eg PMU), since
a CPU might belong in a power-domain on its own (ie one power domain
per-CPU) and basically this means that arch-timers, PMU & company should
link to multiple power domains, ie one per CPU or we find a way to define
a power domain as "banked".

I need to think about this a bit more, thanks for your feedback.

Lorenzo

