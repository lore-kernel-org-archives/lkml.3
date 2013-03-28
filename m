Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3C1QUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:20:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:38688 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab3C1QUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:20:15 -0400
X-IronPort-AV: E=Sophos;i="4.84,927,1355097600"; 
   d="scan'208";a="15430400"
Date: Thu, 28 Mar 2013 16:20:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <20130328160026.GA3026@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1303281617180.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg> <51545BE4.9050206@gmail.com> <alpine.LFD.2.03.1303281135320.1372@syhkavp.arg> <20130328160026.GA3026@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Will Deacon wrote:
> On Thu, Mar 28, 2013 at 03:39:42PM +0000, Nicolas Pitre wrote:
> > On Thu, 28 Mar 2013, Rob Herring wrote:
> > 
> > > On 03/28/2013 09:51 AM, Nicolas Pitre wrote:
> > > > On Thu, 28 Mar 2013, Stefano Stabellini wrote:
> > > > 
> > > >> - the interface to bring up secondary cpus is different and based on
> > > >> PSCI, in fact Xen is going to add a PSCI node to the device tree so that
> > > >> Dom0 can use it.
> > > >>
> > > >> Oh wait, Dom0 is not going to use the PSCI interface even if the node is
> > > >> present on device tree because it's going to prefer the platform smp_ops
> > > >> instead.
> > > > 
> > > > Waitaminute...  I must have missed this part.
> > > > 
> > > > Who said platform specific methods must be used in preference to PSCI?
> > > 
> > > I did. Specifically, I said the platform should be allowed to provide
> > > its own smp_ops. A platform may need to do addtional things on top of
> > > PSCI for example.
> > 
> > Then the platform should have its special hook that would override the 
> > default PSCI methods.  But, by *default* the PSCI methods should be used 
> > if the related DT information is present.
> 
> I'm fine with a default PSCI-based implementation, providing that it's actually
> a layer between the smp ops and the psci code, not just glueing pointers
> together.

OK. I'll rename virt_smp_ops and move it to its own file rather than
psci.c and we'll take it from there.


> KVM and Xen can then use the default implementation, but it does mean that
> they have to agree on that interface as it expands in the future. If Xen
> relies on the default ops in order to boot, then that's a good incentive not
> to deviate from them on the firmware side.

I am OK with that.
