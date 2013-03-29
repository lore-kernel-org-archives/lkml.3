Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3C2RbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:31:06 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:32983 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab3C2RbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:31:05 -0400
Date: Fri, 29 Mar 2013 13:31:01 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        marc.zyngier@arm.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 2/2] arm: prefer PSCI for SMP bringup
In-Reply-To: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.LFD.2.03.1303291320580.1372@syhkavp.arg>
References: <1364575371-8926-2-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013, Stefano Stabellini wrote:

> If PSCI initializes correctly and PSCI SMP operations are available, use them.
> This is required for SMP support in Dom0 on Xen.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: will.deacon@arm.com
> CC: arnd@arndb.de
> CC: marc.zyngier@arm.com
> CC: linux@arm.linux.org.uk
> CC: nico@linaro.org

I'd suggest you also include in your series the patch I posted earlier 
providing a runtime mdesc->smp_init method as well.  This way the 
priority order would be:

- If mdesc->smp_init is non null then use that.

- Otherwise, if PSCI is available then use that.

- Otherwise use mdesc->smp.

This way, if the PSCI default has to be overriden (like in the MCPM case 
because it needs to wrap PSCI itself, or to cover Rob's concern) then 
this can be achieved at run time on a per mdesc basis.


Nicolas
