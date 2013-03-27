Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab3C0SOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:14:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19091 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab3C0SOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:14:53 -0400
X-IronPort-AV: E=Sophos;i="4.84,920,1355097600"; 
   d="scan'208";a="15961903"
Date: Wed, 27 Mar 2013 18:14:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <201303271803.45420.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1303271811380.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1303271642340.4430@kaball.uk.xensource.com> <51533037.5060004@gmail.com> <201303271803.45420.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Arnd Bergmann wrote:
> On Wednesday 27 March 2013, Rob Herring wrote:
> > No, I was thinking in the case of Xen and mach-virt, you would not set
> > mdesc->smp. So you would have something like this:
> > 
> > if (mdesc->smp)
> >         smp_set_ops(mdesc->smp);
> > else
> >         smp_set_ops(&psci_smp_ops);
> 
> The case that Stefano is interested in if obviously other platforms
> that can either run as Dom0 under Xen with psci_smp_ops or natively
> with their own smp_ops. A similar case would be a platform that
> may implement psci using smc when run in secure mode but provide
> its own smp_ops when run natively.

That's correct.


> In both cases, it would be simpler to use psci if available but
> fall back to mdesc->smp otherwise.

I agree.
