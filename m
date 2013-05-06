Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3EFOg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:36:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33352 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3EFOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:36:25 -0400
Date: Mon, 6 May 2013 10:35:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
Message-ID: <20130506143533.GF15278@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1305011939180.5398@kaball.uk.xensource.com>
 <1367436460-10183-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <51817CBE.4050003@codeaurora.org>
 <1367482772.21869.26.camel@zakaz.uk.xensource.com>
 <5182DBA9.9080609@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182DBA9.9080609@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > e.g. if a VCPU sets a timer for NOW+5, but 3 are stolen in the middle it
> > would not make sense (from the guests PoV) for NOW'==NOW+2 at the point
> > where the timer goes off. Nor does it make sense to require that the
> > guest actually be running for 5 before injecting the timer because that
> > would mean real time elapsed time for the timer would be 5+3 in the case
> > where 3 are stolen.
> 
> This is a bit of an aside, but I think that hiding time spent at higher
> privilege levels can be a quite sensible approach to timekeeping in a
> virtualized environment, but I understand that it's not the approach taken
> with Xen, and as you pointed out above, adjusting the Virtual Offset Register
> by itself isn't enough to implement that approach.

This is the approach taken by Xen and KVM. Look in CONFIG_PARAVIRT_CLOCK for
implementation. In the user-space, the entry in 'top' of "stolen" (%st)
is for this exact value.
