Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3C1Pg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:36:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:54125 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983Ab3C1Pgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:36:55 -0400
X-IronPort-AV: E=Sophos;i="4.84,927,1355097600"; 
   d="scan'208";a="16171781"
Date: Thu, 28 Mar 2013 15:36:50 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rob Herring <robherring2@gmail.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <51545BE4.9050206@gmail.com>
Message-ID: <alpine.DEB.2.02.1303281521480.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg> <51545BE4.9050206@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Rob Herring wrote:
> On 03/28/2013 09:51 AM, Nicolas Pitre wrote:
> > On Thu, 28 Mar 2013, Stefano Stabellini wrote:
> > 
> >> - the interface to bring up secondary cpus is different and based on
> >> PSCI, in fact Xen is going to add a PSCI node to the device tree so that
> >> Dom0 can use it.
> >>
> >> Oh wait, Dom0 is not going to use the PSCI interface even if the node is
> >> present on device tree because it's going to prefer the platform smp_ops
> >> instead.
> > 
> > Waitaminute...  I must have missed this part.
> > 
> > Who said platform specific methods must be used in preference to PSCI?
> 
> I did. Specifically, I said the platform should be allowed to provide
> its own smp_ops. A platform may need to do addtional things on top of
> PSCI for example.
> 
> > If DT does provide PSCI description, then PSCI should be used.  Doing 
> > otherwise is senseless.  If PSCI is not to be used, then it should not 
> > be present in DT.
> 
> You can't assume the DT and kernel are in-sync. For example, I've added
> PSCI in the firmware and DTB (part of the firmware), but the highbank
> kernel may or may not use it depending if I convert it.

You are saying that we might want to run an old kernel, without PSCI
support on a machine that exports a DT with PSCI?
But in that case the platform smp_ops will just be chosen as usual.

And if you have a new kernel with PSCI support on a machine that exports
a DT with PSCI won't be OK to use the PSCI calls?

The only problematic case would be if you actually need some platform
specific calls to wrap around the PSCI firmare interface. But in that
case what is the point of exporting the PSCI node on device tree anyway?
