Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967640Ab3DRQkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:40:10 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:45106 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936231Ab3DRQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:40:08 -0400
Date: Thu, 18 Apr 2013 12:40:05 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 1/4] arm: introduce psci_smp_ops
In-Reply-To: <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1304181237480.17375@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Stefano Stabellini wrote:

> On Thu, 18 Apr 2013, Russell King - ARM Linux wrote:
> > This should allow the Xen problem to be resolved, because Xen will
> > provide the PSCI operations, and it's correct in that case to override
> > the platform's SMP operations.
> 
> Yes, increasing the priority of PSCI helps Xen a lot.
> In order to completely solve the issue for Xen though, another patch is
> needed (http://marc.info/?l=linux-kernel&m=136630106201968&w=2) because
> of the introduction of smp_init.

Please look at the latest smp_init patch version I sent to you.  It 
shouldn't conflict with Xen any longer.  It now returns a bool result 
depending on whether it did set up smp_ops or not.


Nicolas
