Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3FCNPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:15:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32929 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab3FCNPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:15:32 -0400
Date: Mon, 3 Jun 2013 14:15:27 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Achin Gupta <Achin.Gupta@arm.com>
Subject: Re: [RFC PATCH 2/3] drivers: mfd: vexpress: add timeout API to
 vexpress config interface
Message-ID: <20130603131527.GC22821@e102568-lin.cambridge.arm.com>
References: <1369399986-15649-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1369399986-15649-3-git-send-email-lorenzo.pieralisi@arm.com>
 <1370254532.3407.36.camel@linaro1.home>
 <20130603115219.GA22821@e102568-lin.cambridge.arm.com>
 <1370261030.16073.5.camel@linaro1.home>
MIME-Version: 1.0
In-Reply-To: <1370261030.16073.5.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 03 Jun 2013 13:15:28.0374 (UTC) FILETIME=[6AB3A960:01CE605C]
X-MC-Unique: 113060314153005301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 01:03:50PM +0100, Jon Medhurst (Tixy) wrote:
> On Mon, 2013-06-03 at 12:52 +0100, Lorenzo Pieralisi wrote:
> > On Mon, Jun 03, 2013 at 11:15:32AM +0100, Jon Medhurst (Tixy) wrote:
> > > On Fri, 2013-05-24 at 13:53 +0100, Lorenzo Pieralisi wrote:
> > > > In case some transactions to the Serial Power Controller (SPC) are lost owing
> > > > to multiple operations handled at once by the M3 controller the OS needs to
> > > > rely on a configuration API that can time out so that failures do not result
> > > > in an unusable system.
> > > > 
> > > > This patch adds a timeout API to the vexpress config programming interface,
> > > > and refactors the existing read/write functions so that they can be reused
> > > > seamlessly on top of the newly defined API.
> > > 
> > > Isn't one of the main purposes of the config interface to serialise
> > > transactions to the config bus, so why would the SPC be handling
> > > multiple transactions at once? And if we can in fact loose transactions
> > > doesn't this mean we get random failures in the system? E.g. if this
> > > happened at boot in vexpress_spc_populate_opps then cpufreq will fail.
> > 
> > It has more to do with firmware carrying out background operations like
> > powering up a cluster when a DVFS is requested.
> 
> Would that make it drop transactions or just take a longer time to get
> around to servicing them?

It should just take longer to service them, that's what the behaviour
should be.

Lorenzo

