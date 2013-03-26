Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab3CZPrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:47:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965141Ab3CZPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:47:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
Date: Tue, 26 Mar 2013 15:46:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <alpine.DEB.2.02.1303261509080.4430@kaball.uk.xensource.com> <20130326153730.GA22368@mudshark.cambridge.arm.com>
In-Reply-To: <20130326153730.GA22368@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261546.50194.arnd@arndb.de>
X-Provags-ID: V02:K0:KO1YpK5B7OWT0WW2D4ZZUn9El4esrmytaY3GXUT+f+0
 X/hqgMyqvWyoPO0IgCJXgXJ+5gUq2u/5XanNRX/syREnZKeJR8
 uzUufFkiepwkYEH0olPP4mC+cqDcV/rDmNhxWAzjvVtoOl4swz
 18EZDe9EMEM/A1/WmS1GAdCbzmAwXoxifxhXOYygVFm9zHhMS7
 JYxl0Nyx6n1V8CPMJ5LAOJLXNhd7s2RqBu2Tb71ri7hGvwYTf7
 b3KJf3O0WU4DJJ7Go/6+pTOv/gMGnI9HQ1fOk9rCFs6WGd5UYH
 zHA9pC2QJE0lhrNtxZCRhOMeLXTV7iIUWWT56FWyrvZ6LNvCpM
 Xud8muOkSHeJK13P3abg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Will Deacon wrote:
> > They can even base the implementation of their smp_ops on the current
> > psci code, in order to facilitate that I could get rid of psci_ops
> > (which initialization is based on device tree) and export the psci_cpu_*
> > functions instead, so that they can be called directly by other smp_ops.
> 
> Again, I think this destroys the layering. The whole point is that the PSCI
> functions are called from within something that understands precisely how to
> talk to the firmware and what it is capable of.

Right, we probably the psci smp ops to be separate from the rest of the psci
code, but I also think that Stefano is right that we should let any platform
use the psci smp ops if possible, rather than having to implement their own.

> > > If this can indeed work for the virtual platforms (Xen and KVM), then I
> > > think it would be better expressed using `virt' smp_ops, which map directly
> > > to PSCI, rather than putting them here. Even then, it's tying KVM and Xen
> > > together on the firmware side of things...
> > 
> > Keep in mind that dom0 on Xen boots as a native machine (versatile
> > express or exynos5 for example) with a Xen hypervisor node on it.  We
> > would need to find a way to override the default machine smp_ops with
> > a set of xen_smp_ops early at boot.
> > I don't like this option very much, I think is fragile.
> 
> Why can't dom0 use whatever smp ops the native machine would use?

The part that I'm most interested in is making it possible for a platform
to kill off its native smp ops in the kernel by implementing the psci
ops. I think it's a good strategy to use psci by default if both 
platform and psci implementations are available.

	Arnd
