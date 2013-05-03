Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133Ab3ECKnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 06:43:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45084 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763107Ab3ECKn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 06:43:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,602,1363132800"; 
   d="scan'208";a="23129977"
Date: Fri, 3 May 2013 11:43:23 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Christopher Covington <cov@codeaurora.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 1/3] arm_arch_timer: introduce
 arch_timer_stolen_ticks
In-Reply-To: <5182DBA9.9080609@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1305031130210.5398@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com> <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com> <51817CBE.4050003@codeaurora.org> <1367482772.21869.26.camel@zakaz.uk.xensource.com>
 <5182DBA9.9080609@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Christopher Covington wrote:
> > So the virtual timer should appear to have been running even while time
> > is being stolen and therefore stolen time needs to be accounted via some
> > other means.
> 
> Something that's not currently obvious to me is that given that the stolen
> cycle accounting should be done, what makes the architected timer interrupt
> handler the ideal place to do it?

That is a good question and I would appreciate suggestions to improve
the patch.

Given that Xen x86 and ia64 does stolen time accounting from the timer
interrupt handler:

arch/x86/xen/time.c:xen_timer_interrupt
arch/ia64/kernel/time.c:timer_interrupt

and given that the arch_timer is the only timer used by Xen on ARM and
that it includes a virt_timer that is made on purpose to be used by
virtual machines, I thought that it might be a good place for it.

I also thought that doing it this way, KVM should be able to reuse the
same hook.
