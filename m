Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaIYKnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:43:10 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57274 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaIYKnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:43:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, chris@zankel.net, cmetcalf@tilera.com,
        davem@davemloft.net, deller@gmx.de, dhowells@redhat.com,
        geert@linux-m68k.org, heiko.carstens@de.ibm.com, hpa@zytor.com,
        jcmvbkbc@gmail.com, jesper.nilsson@axis.com, mingo@redhat.com,
        monstr@monstr.eu, paulmck@linux.vnet.ibm.com, rdunlap@infradead.org,
        sam@ravnborg.org, schwidefsky@de.ibm.com, starvik@axis.com,
        takata@linux-m32r.org, tglx@linutronix.de, tony.luck@intel.com,
        daniel.thompson@linaro.org, broonie@linaro.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO accessors
Date: Thu, 25 Sep 2014 12:42:15 +0200
Message-ID: <4515310.nYRWfN5AyO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oPx1MwP1gyxTO8Y/UqeVbBW6YfDwKY05B8YIYBinxvB
 mJcgPnefBEHtOEnaEmRko6QDJ3Caw/LqOjfjvtr5sMpofZWyoH
 C3CaCKiTXRlJrYrNDELhpVdbAAugk2JtMxGq9/LrOwd/3v79lH
 qJLe+6/73+KGks4LFd+ddtx5i+QQanXplYAxJ2/NzGDZzdrLbZ
 W+fGfUMWWz2TuPvPUdoJz+wCuvUvI76xm8cC0ybFqw0KKxRl+i
 cuKFYZaif54P+HvADZIpcuRA482p45zFM44tjIoJWvZGEy0Ws5
 Ksn0BAjdbQbiMA1ePF62REwKi+aUEtcIMmUaCBzEaQrgPxPWPp
 c8EBHK3aIUGVE0Jcgr1c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 18:17:19 Will Deacon wrote:
> 
> This is version three of the series I've originally posted here:
> 
>   v1: https://lkml.org/lkml/2014/4/17/269
>   v2: https://lkml.org/lkml/2014/5/22/468
> 
> This is basically just a rebase on top of 3.17-rc6, minus the alpha patch
> (which was merged into mainline).
> 
> I looked at reworking the non-relaxed accessors to imply mmiowb, but it
> quickly got messy as some architectures (e.g. mips) deliberately keep
> mmiowb and readX/writeX separate whilst others (e.g. powerpc) don't trust
> drivers to get mmiowb correct, so add barriers to both. Given that
> arm/arm64/x86 don't care about mmiowb, I've left that as an exercise for
> an architecture that does care.
> 
> In order to get this lot merged, we probably want to merge the asm-generic
> patch (1/17) first, so Acks would be much appreciated on the architecture
> bits.
> 
> As before, I've included the original cover letter below, as that describes
> what I'm trying to do in more detail.
> 

I'm definitely happy to merge that first patch in the asm-generic tree, or
have it go through some other tree along with architecture specific patches.
Anything that helps get these functions across all architectures really.

I don't think there is any controversy about whether or not we should
have the functions, or what the default should be on architectures that
don't provide their own, so I wonder why we can't just add the conditional
definitions to linux/io.h and remove the trivial definitions from
architectures afterwards.

	Arnd
