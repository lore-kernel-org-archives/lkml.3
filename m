Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab3DEXPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:15:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1357 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab3DEXPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:15:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,418,1363132800"; 
   d="scan'208";a="17016625"
Date: Sat, 6 Apr 2013 00:15:45 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rob Herring <robherring2@gmail.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 4/4] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <515F392B.1030200@gmail.com>
Message-ID: <alpine.DEB.2.02.1304060015150.5353@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-4-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1304051217560.1171@syhkavp.arg> <alpine.DEB.2.02.1304051725580.21065@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304051324190.1171@syhkavp.arg> <515F392B.1030200@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Rob Herring wrote:
> On 04/05/2013 02:36 PM, Nicolas Pitre wrote:
> > On Fri, 5 Apr 2013, Stefano Stabellini wrote:
> > 
> >> This is what happens:
> >>
> >> - No Xen
> >> Xen is not running on the platform and a Xen hypervisor node is not
> >> available on device tree.
> >> Everything keeps working seamlessly, this patch doesn't change anything.
> >>
> >> - we are running on Xen
> >> Xen is running on the platform, we are running as a guest on Xen and an
> >> hypervisor node is available on device tree.
> >> Let's also assume that there aren't any "arm,cci" compatible nodes on
> >> device tree because Xen wouldn't export this kind of information to any
> >> guests right now. Therefore PSCI should be used to boot secondary cpus.
> >> Because the versatile express machine sets smp_init to
> >> vexpress_smp_init_ops, vexpress_smp_init_ops will be called.
> >> vexpress_smp_init_ops sets smp_ops to vexpress_smp_ops, that *break*
> >> Xen.
> > 
> > OK I see.
> > 
> >> With this patch, xen_smp_init will be called instead of
> >> vexpress_smp_init_ops, and smp_ops will be set to psci_smp_ops,
> >> therefore *unbreaking* Xen.
> > 
> > However that breaks MCPM.
> 
> You mean on bare metal, right? For the bare metal, "xen,xen" property
> would not be present and xen_smp_init is not used. So the vexpress MCPM
> ops will be used.

That is correct.


> Aren't Dom0 cpu's basically virtual cpus? If Xen ever
> needs the MCPM support, the Xen hook itself can figure out whether to
> use MCPM support.

Right.
