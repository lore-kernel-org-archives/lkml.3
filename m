Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162643Ab3DETgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:36:11 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:59678 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162615Ab3DETgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:36:10 -0400
Date: Fri, 5 Apr 2013 15:36:06 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v6 4/4] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <alpine.DEB.2.02.1304051725580.21065@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1304051324190.1171@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-4-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1304051217560.1171@syhkavp.arg> <alpine.DEB.2.02.1304051725580.21065@kaball.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Stefano Stabellini wrote:

> This is what happens:
> 
> - No Xen
> Xen is not running on the platform and a Xen hypervisor node is not
> available on device tree.
> Everything keeps working seamlessly, this patch doesn't change anything.
> 
> - we are running on Xen
> Xen is running on the platform, we are running as a guest on Xen and an
> hypervisor node is available on device tree.
> Let's also assume that there aren't any "arm,cci" compatible nodes on
> device tree because Xen wouldn't export this kind of information to any
> guests right now. Therefore PSCI should be used to boot secondary cpus.
> Because the versatile express machine sets smp_init to
> vexpress_smp_init_ops, vexpress_smp_init_ops will be called.
> vexpress_smp_init_ops sets smp_ops to vexpress_smp_ops, that *break*
> Xen.

OK I see.

> With this patch, xen_smp_init will be called instead of
> vexpress_smp_init_ops, and smp_ops will be set to psci_smp_ops,
> therefore *unbreaking* Xen.

However that breaks MCPM.

> In fact what makes this patch really necessary is smp_init together with
> the MCPM series.

Yes.

> Do you agree with me?

On the Xen issue, yes.


Nicolas
