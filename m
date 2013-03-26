Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab3CZQEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:04:53 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:64107 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965243Ab3CZQD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:03:57 -0400
Date: Tue, 26 Mar 2013 12:03:54 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Will Deacon <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
In-Reply-To: <201303261546.50194.arnd@arndb.de>
Message-ID: <alpine.LFD.2.03.1303261201530.1372@syhkavp.arg>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <alpine.DEB.2.02.1303261509080.4430@kaball.uk.xensource.com> <20130326153730.GA22368@mudshark.cambridge.arm.com> <201303261546.50194.arnd@arndb.de>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Arnd Bergmann wrote:

> On Tuesday 26 March 2013, Will Deacon wrote:
> > > They can even base the implementation of their smp_ops on the current
> > > psci code, in order to facilitate that I could get rid of psci_ops
> > > (which initialization is based on device tree) and export the psci_cpu_*
> > > functions instead, so that they can be called directly by other smp_ops.
> > 
> > Again, I think this destroys the layering. The whole point is that the PSCI
> > functions are called from within something that understands precisely how to
> > talk to the firmware and what it is capable of.
> 
> Right, we probably the psci smp ops to be separate from the rest of the psci
> code, but I also think that Stefano is right that we should let any platform
> use the psci smp ops if possible, rather than having to implement their own.

Oh absolutely.  It is always best to use an existing standard.  But PSCI 
probably won't be the only firmware interface standard.  It therefore 
shouldn't be used as the Linux internal interface model.


Nicolas
