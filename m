Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3FXPn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:43:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46442 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3FXPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:43:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,929,1363132800"; 
   d="scan'208";a="31476465"
Date: Mon, 24 Jun 2013 16:43:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Chen Gang <gang.chen@asianux.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [Suggestion] arch: arm64: xen: "ln -s" the paravirt.h from
 arm.
In-Reply-To: <51C81A39.5060909@asianux.com>
Message-ID: <alpine.DEB.2.02.1306241639260.4782@kaball.uk.xensource.com>
References: <51C53C06.7050205@asianux.com> <51C81115.4070803@asianux.com> <51C81A39.5060909@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, Chen Gang wrote:
> Hello Maintainers:
> 
> if 'CONFIG_XEN'
> 
>   CC      arch/arm64/xen/../../arm/xen/enlighten.o
> arch/arm64/xen/../../arm/xen/enlighten.c:19:26: fatal error: asm/paravirt.h: No such file or directory
> 
> The related .config file for next-20130624 is in attachment.
> 
> 
> If "ln -s ../../../arm/include/asm/paravirt.h paravirt.h", it can pass
> compiling, but I do not know how to make a patch for it ("ln -s ..."),
> Do we have another more suitable ways for it (or another fixing ways) ?
> 
> Welcome any suggestions or completions.

The problem is caused by:

commit 3a885582a366caf868b0782041c44854ff4c3568
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Wed May 29 10:56:34 2013 +0000

    xen/arm: account for stolen ticks

that is in my tree for linux-next (even though I have not received any
replies from the ARM maintainers so I don't know when and if it is going
to go upstream).

I think that the best thing to do would be to add a couple of ifdef
CONFIG_PARAVIRT in arch/arm/xen/enlighten.c. I'll add them to my tree.
